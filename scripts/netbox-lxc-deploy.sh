#!/usr/bin/env bash
# ============================================================================
#  NetBox LXC Deploy  ·  ensecnet
#  Proxmox VE: unprivileged LXC (Debian 12) + Docker CE + netbox-docker
#
#  Interactive wizard — asks for all configuration up front, then deploys
#  semi-automatically: pulls current versions, starts the stack, waits for
#  health, installs a systemd unit + appliance-style login console.
#
#  One-line bootstrap (run on a Proxmox VE node, as root):
#    bash -c "$(curl -fsSL https://raw.githubusercontent.com/ensecnet/netbox-lxc/main/scripts/netbox-lxc-deploy.sh)"
#
#  Or clone and run:
#    git clone https://github.com/ensecnet/netbox-lxc.git
#    bash netbox-lxc/scripts/netbox-lxc-deploy.sh
# ============================================================================
set -euo pipefail

# ANSI colours — $'...' form so they render in the Proxmox web console too.
RED=$'\033[0;31m'; GREEN=$'\033[0;32m'; YELLOW=$'\033[1;33m'
CYAN=$'\033[0;36m'; BLUE=$'\033[0;34m'; BOLD=$'\033[1m'; NC=$'\033[0m'

log()     { echo -e "${CYAN}[*]${NC} $*"; }
ok()      { echo -e "${GREEN}[OK]${NC} $*"; }
warn()    { echo -e "${YELLOW}[!]${NC} $*"; }
err()     { echo -e "${RED}[ERR]${NC} $*" >&2; exit 1; }
section() { echo; echo -e "${BOLD}${BLUE}── $* ──${NC}"; }

command -v pct &>/dev/null || err "pct not found — are you on a Proxmox VE node?"

# ── Banner ──────────────────────────────────────────────────────────────────
clear
echo -e "${BOLD}${CYAN}"
cat << 'EOF'
   _ __   ___| |_| |__   _____  __
  | '_ \ / _ \ __| '_ \ / _ \ \/ /
  | | | |  __/ |_| |_) | (_) >  <
  |_| |_|\___|\__|_.__/ \___/_/\_\

     NetBox LXC Deployer for Proxmox VE  ·  v1.0
     Debian 12 Bookworm + Docker CE + netbox-docker
     ensecnet · open-source infrastructure
EOF
echo -e "${NC}"

# ── Wizard: base config ───────────────────────────────────────────────────────
section "Wizard — base configuration"

while true; do
  read -rp "  Container VMID [310]: " CT_ID; CT_ID="${CT_ID:-310}"
  pct status "$CT_ID" &>/dev/null && { warn "VMID ${CT_ID} already exists!"; continue; }
  [[ "$CT_ID" =~ ^[0-9]+$ ]] && (( CT_ID >= 100 )) && break
  warn "Invalid VMID (min 100)."
done

read -rp "  Hostname [netbox]: " CT_HOSTNAME; CT_HOSTNAME="${CT_HOSTNAME:-netbox}"

while true; do
  read -rsp "  LXC root password: " ROOT_PASS; echo
  read -rsp "  Confirm: " ROOT_PASS2; echo
  [[ "$ROOT_PASS" == "$ROOT_PASS2" && -n "$ROOT_PASS" ]] && break
  warn "Mismatch or empty."
done

read -rp "  NetBox admin user [admin]: " NB_USER; NB_USER="${NB_USER:-admin}"
read -rp "  NetBox admin email [admin@example.test]: " NB_EMAIL; NB_EMAIL="${NB_EMAIL:-admin@example.test}"
while true; do
  read -rsp "  NetBox admin password (min 8): " NB_PASS; echo
  read -rsp "  Confirm: " NB_PASS2; echo
  [[ "$NB_PASS" == "$NB_PASS2" ]] || { warn "Mismatch."; continue; }
  (( ${#NB_PASS} >= 8 )) || { warn "Too short."; continue; }
  break
done

echo; log "Available storage:"
pvesm status | awk 'NR>1 {printf "    %-20s %s\n", $1, $2}'
read -rp "  Storage [local-lvm]: " CT_STORAGE; CT_STORAGE="${CT_STORAGE:-local-lvm}"
pvesm status | grep -q "^${CT_STORAGE}" || err "Storage '${CT_STORAGE}' does not exist."
read -rp "  Disk GB [16]: "  CT_DISK; CT_DISK="${CT_DISK:-16}"
read -rp "  RAM MB [4096]: " CT_RAM;  CT_RAM="${CT_RAM:-4096}"
read -rp "  CPU cores [2]: " CT_CPU;  CT_CPU="${CT_CPU:-2}"
read -rp "  NetBox HTTP port [8000]: " NB_PORT; NB_PORT="${NB_PORT:-8000}"

# ── Wizard: network ───────────────────────────────────────────────────────────
section "Wizard — network configuration"

echo "  Available bridges:"
ip link show type bridge 2>/dev/null | awk -F': ' '/^[0-9]/{print "    "$2}'
echo
read -rp "  Bridge [vmbr0]: " NET_BRIDGE; NET_BRIDGE="${NET_BRIDGE:-vmbr0}"
ip link show "$NET_BRIDGE" &>/dev/null || \
  err "Bridge '${NET_BRIDGE}' not found. Available: $(ip link show type bridge | grep -oP '(?<=: )\w+' | tr '\n' ' ')"
read -rp "  IP/CIDR [192.0.2.10/24]: " NET_IP; NET_IP="${NET_IP:-192.0.2.10/24}"
read -rp "  Gateway [192.0.2.1]: " NET_GW;     NET_GW="${NET_GW:-192.0.2.1}"
read -rp "  DNS [1.1.1.1]: " NET_DNS;          NET_DNS="${NET_DNS:-1.1.1.1}"
read -rp "  VLAN tag (empty = none): " NET_VLAN
VLAN_OPT=""; [[ -n "${NET_VLAN}" ]] && VLAN_OPT=",tag=${NET_VLAN}"

# ── Versions (current by default; can be pinned) ──────────────────────────────
section "Wizard — versions"
read -rp "  netbox-docker branch/tag [release]: " NBD_REF; NBD_REF="${NBD_REF:-release}"
read -rp "  Enable auto-update timer? [y/N]: " AUTO_UPD; AUTO_UPD="${AUTO_UPD:-N}"

# ── Confirm ───────────────────────────────────────────────────────────────────
section "Summary"
cat <<SUMMARY
  VMID/host : ${CT_ID} / ${CT_HOSTNAME}
  Resources : ${CT_CPU} vCPU · ${CT_RAM} MB · ${CT_DISK} GB on ${CT_STORAGE}
  Network   : ${NET_IP} gw ${NET_GW} dns ${NET_DNS} on ${NET_BRIDGE}${VLAN_OPT:+ (vlan ${NET_VLAN})}
  NetBox    : http://${NET_IP%%/*}:${NB_PORT}  ·  admin: ${NB_USER}
  Source    : netbox-docker @ ${NBD_REF}  ·  auto-update: ${AUTO_UPD}
SUMMARY
read -rp "  Proceed? [Y/n]: " GO; [[ "${GO:-Y}" =~ ^[Yy]?$ ]] || { warn "Aborted."; exit 0; }

# ── Create LXC ────────────────────────────────────────────────────────────────
section "Provisioning LXC ${CT_ID}"
TEMPLATE="$(pveam available 2>/dev/null | awk '/debian-12-standard/{print $2}' | sort | tail -1)"
[[ -z "$TEMPLATE" ]] && TEMPLATE="debian-12-standard_12.7-1_amd64.tar.zst"
if ! pveam list local 2>/dev/null | grep -q "$TEMPLATE"; then
  log "Downloading template ${TEMPLATE}..."
  pveam download local "$TEMPLATE" || warn "Template download failed — ensure it is present."
fi

NET0="name=eth0,bridge=${NET_BRIDGE},ip=${NET_IP},gw=${NET_GW}${VLAN_OPT}"
pct create "$CT_ID" "local:vztmpl/${TEMPLATE}" \
  --hostname "$CT_HOSTNAME" \
  --cores "$CT_CPU" --memory "$CT_RAM" \
  --rootfs "${CT_STORAGE}:${CT_DISK}" \
  --net0 "$NET0" --nameserver "$NET_DNS" \
  --features "nesting=1,keyctl=1" \
  --unprivileged 1 --onboot 1 --password "$ROOT_PASS"
ok "LXC ${CT_ID} created."

pct start "$CT_ID"; sleep 5; ok "LXC started."

# ── Docker CE inside ──────────────────────────────────────────────────────────
section "Installing Docker CE"
pct exec "$CT_ID" -- bash -c '
  set -e
  apt-get update -qq
  apt-get install -y -qq ca-certificates curl git >/dev/null
  install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
  chmod a+r /etc/apt/keyrings/docker.asc
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian bookworm stable" > /etc/apt/sources.list.d/docker.list
  apt-get update -qq
  apt-get install -y -qq docker-ce docker-ce-cli containerd.io docker-compose-plugin >/dev/null
  systemctl enable --now docker
'
ok "Docker CE installed."

# ── Deploy netbox-docker ──────────────────────────────────────────────────────
section "Deploying NetBox (netbox-docker @ ${NBD_REF})"
pct exec "$CT_ID" -- bash -c "
  set -e
  mkdir -p /opt/netbox
  git clone -b '${NBD_REF}' --depth 1 https://github.com/netbox-community/netbox-docker.git /opt/netbox/netbox-docker
  cd /opt/netbox/netbox-docker
  SECRET=\$(openssl rand -base64 40 | tr -dc 'a-zA-Z0-9' | head -c 50)
  cat > docker-compose.override.yml <<DCEOF
services:
  netbox:
    ports:
      - ${NB_PORT}:8080
DCEOF
  printf 'SECRET_KEY=%s\n' \"\$SECRET\" >> env/netbox.env
  printf 'SUPERUSER_NAME=%s\nSUPERUSER_EMAIL=%s\nSUPERUSER_PASSWORD=%s\n' \
    '${NB_USER}' '${NB_EMAIL}' '${NB_PASS}' >> env/netbox.env
  docker compose pull
  docker compose up -d
"
ok "Stack started — pulling current images."

# ── Wait for health ───────────────────────────────────────────────────────────
section "Waiting for NetBox to become ready"
for i in $(seq 1 36); do
  CODE="$(pct exec "$CT_ID" -- bash -c "curl -s -o /dev/null -w '%{http_code}' http://localhost:${NB_PORT}/login/ 2>/dev/null || echo 000")"
  [[ "$CODE" == "200" ]] && { echo; ok "NetBox is up (HTTP 200)."; break; }
  echo -ne "${CYAN}.${NC}"; sleep 5
  [[ $i -eq 36 ]] && { echo; warn "Timeout — check logs via the console."; }
done

# ── systemd unit + auto-update (optional) ─────────────────────────────────────
section "Installing systemd unit"
pct exec "$CT_ID" -- bash -c '
cat > /etc/systemd/system/netbox-docker.service <<SVC
[Unit]
Description=NetBox Docker Compose Stack
Requires=docker.service
After=docker.service network-online.target
[Service]
Type=oneshot
RemainAfterExit=yes
WorkingDirectory=/opt/netbox/netbox-docker
ExecStart=/usr/bin/docker compose up -d
ExecStop=/usr/bin/docker compose down
TimeoutStartSec=300
[Install]
WantedBy=multi-user.target
SVC
systemctl daemon-reload
systemctl enable netbox-docker.service
'
ok "systemd unit installed."

if [[ "$AUTO_UPD" =~ ^[Yy]$ ]]; then
  pct exec "$CT_ID" -- bash -c '
cat > /usr/local/sbin/netbox-update.sh <<UPD
#!/usr/bin/env bash
set -e
cd /opt/netbox/netbox-docker
docker compose pull
docker compose up -d
docker image prune -f
UPD
chmod +x /usr/local/sbin/netbox-update.sh
cat > /etc/systemd/system/netbox-update.service <<SVC
[Unit]
Description=NetBox image auto-update
[Service]
Type=oneshot
ExecStart=/usr/local/sbin/netbox-update.sh
SVC
cat > /etc/systemd/system/netbox-update.timer <<TMR
[Unit]
Description=Weekly NetBox image update
[Timer]
OnCalendar=weekly
Persistent=true
[Install]
WantedBy=timers.target
TMR
systemctl daemon-reload
systemctl enable --now netbox-update.timer
'
  ok "Auto-update timer enabled (weekly)."
fi

# ── Install appliance console + login menu ────────────────────────────────────
section "Installing appliance console"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -f "${SCRIPT_DIR}/netbox-console.sh" ]]; then
  pct push "$CT_ID" "${SCRIPT_DIR}/netbox-console.sh" /usr/local/sbin/netbox-console.sh
  pct exec "$CT_ID" -- chmod +x /usr/local/sbin/netbox-console.sh
  pct exec "$CT_ID" -- bash -c "
cat > /etc/profile.d/netbox-console.sh <<'EOF'
#!/bin/bash
if [[ \$- == *i* ]] && [[ -x /usr/local/sbin/netbox-console.sh ]]; then
  /usr/local/sbin/netbox-console.sh
fi
EOF
chmod +x /etc/profile.d/netbox-console.sh
"
  ok "Appliance console installed (auto-launch on login)."
else
  warn "netbox-console.sh not found next to deployer — skipping console install."
fi

# ── Done ──────────────────────────────────────────────────────────────────────
CTIP="${NET_IP%%/*}"
echo
echo -e "${BOLD}${GREEN}════════════════════════════════════════════════${NC}"
echo -e "${BOLD}${GREEN}  DEPLOYMENT SUCCESSFUL${NC}"
echo -e "${BOLD}${GREEN}════════════════════════════════════════════════${NC}"
echo -e "  URL      : ${CYAN}http://${CTIP}:${NB_PORT}${NC}"
echo -e "  Login    : ${CYAN}${NB_USER}${NC} / (the password you set)"
echo -e "  Console  : ${YELLOW}pct enter ${CT_ID}${NC}  (auto-launches menu)"
echo -e "  Service  : ${YELLOW}systemctl status netbox-docker${NC}"
echo -e "${BOLD}${GREEN}════════════════════════════════════════════════${NC}"
echo
