#!/usr/bin/env bash
# ============================================================================
#  NetBox Appliance Console  ·  ensecnet
#  Status screen + management menu, auto-launched on interactive login.
#  Style: pfSense / OPNsense / Home Assistant OS console.
#
#  Installed by the deployer to /usr/local/sbin/netbox-console.sh and
#  auto-launched via /etc/profile.d/netbox-console.sh on interactive login.
# ============================================================================

COMPOSE_DIR="/opt/netbox/netbox-docker"
GREEN=$'\033[0;32m'; YELLOW=$'\033[1;33m'; RED=$'\033[0;31m'
CYAN=$'\033[0;36m'; BOLD=$'\033[1m'; DIM=$'\033[2m'; NC=$'\033[0m'

svc_state() {
  # $1 = container name fragment; prints a coloured status dot + text
  local frag="$1" line
  line="$(docker ps --format '{{.Names}} {{.Status}}' 2>/dev/null | grep -m1 "$frag" || true)"
  if [[ -z "$line" ]]; then
    printf '%s● stopped%s' "$RED" "$NC"
  elif echo "$line" | grep -qi 'healthy\|Up'; then
    printf '%s● running%s' "$GREEN" "$NC"
  else
    printf '%s● starting%s' "$YELLOW" "$NC"
  fi
}

status_screen() {
  clear
  local ip; ip="$(hostname -I 2>/dev/null | awk '{print $1}')"
  local port; port="$(grep -oP '(?<=- )\d+(?=:8080)' "${COMPOSE_DIR}/docker-compose.override.yml" 2>/dev/null | head -1)"
  port="${port:-8000}"

  echo -e "${BOLD}${CYAN}"
  cat << 'EOF'
   _   _      _   ____
  | \ | | ___| |_| __ )  _____  __
  |  \| |/ _ \ __|  _ \ / _ \ \/ /
  | |\  |  __/ |_| |_) | (_) >  <
  |_| \_|\___|\__|____/ \___/_/\_\
EOF
  echo -e "${NC}${DIM}  appliance console · ensecnet${NC}"
  echo
  printf "  %-14s %s\n" "Host:"    "$(hostname)"
  printf "  %-14s %s\n" "Address:" "http://${ip}:${port}"
  printf "  %-14s %s\n" "Uptime:"  "$(uptime -p 2>/dev/null | sed 's/^up //')"
  echo -e "  ${DIM}────────────────────────────────────────────────${NC}"
  echo -e "  ${BOLD}SERVICES${NC}"
  printf "  %-18s %s\n" "NetBox"     "$(svc_state netbox-1)"
  printf "  %-18s %s\n" "Worker"     "$(svc_state worker)"
  printf "  %-18s %s\n" "PostgreSQL" "$(svc_state postgres)"
  printf "  %-18s %s\n" "Redis"      "$(svc_state redis)"
  echo -e "  ${DIM}────────────────────────────────────────────────${NC}"
  echo -e "  ${BOLD}MENU${NC}"
  echo "   1) Service status (detailed)"
  echo "   2) Restart NetBox stack"
  echo "   3) Update NetBox (pull current images)"
  echo "   4) View logs (follow)"
  echo "   5) Reset admin password"
  echo "   6) Shell (root bash)"
  echo "   7) Reboot appliance"
  echo "   0) Logout"
  echo -e "  ${DIM}────────────────────────────────────────────────${NC}"
}

menu() {
  status_screen
  read -rp "  Select [0-7]: " choice
  case "$choice" in
    1) docker compose -f "${COMPOSE_DIR}/docker-compose.yml" ps; read -rp "  Enter..." ;;
    2) ( cd "$COMPOSE_DIR" && docker compose restart ); read -rp "  Enter..." ;;
    3) ( cd "$COMPOSE_DIR" && docker compose pull && docker compose up -d && docker image prune -f ); read -rp "  Enter..." ;;
    4) ( cd "$COMPOSE_DIR" && docker compose logs -f --tail=80 ) ;;
    5) ( cd "$COMPOSE_DIR" && docker compose exec netbox /opt/netbox/netbox/manage.py changepassword admin ); read -rp "  Enter..." ;;
    6) bash ;;
    7) read -rp "  Reboot? [y/N]: " c; [[ "$c" =~ ^[Yy]$ ]] && reboot ;;
    0) exit 0 ;;
    *) ;;
  esac
}

while true; do menu; done
