<div align="center">

# NetBox LXC Deploy

**Lightweight, reproducible NetBox (IPAM / Source of Truth) for Proxmox VE**

Interactive install wizard · appliance-style status console · one-command bootstrap

[![Docs](https://img.shields.io/badge/📖_Documentation-View_full_docs-0bb3a0?style=for-the-badge)](https://ensecnet.github.io/netbox-lxc/)
[![License](https://img.shields.io/badge/License-Apache_2.0-131c2b?style=for-the-badge)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Proxmox_VE_·_LXC-131c2b?style=for-the-badge)](https://www.proxmox.com/)

</div>

---

> ### 📖 [**Read the full documentation →**](https://ensecnet.github.io/netbox-lxc/)
>
> The complete guide — deployment walk-through, appliance console reference, and
> update strategy — is published as a documentation site with sidebar navigation.
> This README is the quick start; the docs site is the manual.

---

## What it does

One command on a Proxmox node pulls everything, an interactive wizard asks what
it needs, and the rest runs semi-automatically: current images are downloaded,
the stack is started, health is verified, and an appliance-style status console
is installed on login. The run ends with a clear `DEPLOYMENT SUCCESSFUL` banner.

- **NetBox** as the official `netbox-docker` stack inside an **unprivileged** LXC
- **Interactive wizard** — every setting via prompts, no file editing
- **Current versions** by default, with optional version pinning
- **Optional weekly auto-update** (systemd timer)
- **Appliance console** — status screen + management menu, auto-launched on login

## Quick start

On a Proxmox VE node, as root:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ensecnet/netbox-lxc/main/scripts/netbox-lxc-deploy.sh)"
```

The node downloads the script, the wizard asks for configuration (VMID, hostname,
credentials, storage, network, versions), and the deploy runs to `SUCCESSFUL`.

> Prefer to read before you run?
> ```bash
> git clone https://github.com/ensecnet/netbox-lxc.git
> less netbox-lxc/scripts/netbox-lxc-deploy.sh   # read it
> bash netbox-lxc/scripts/netbox-lxc-deploy.sh   # run it
> ```

## What you get

```
════════════════════════════════════════════════
  DEPLOYMENT SUCCESSFUL
════════════════════════════════════════════════
  URL      : http://192.0.2.10:8000
  Login    : admin / (the password you set)
  Console  : pct enter 310  (auto-launches menu)
  Service  : systemctl status netbox-docker
════════════════════════════════════════════════
```

Enter the container with `pct enter 310` and an appliance console launches
automatically — live service health plus a management menu, no commands to
remember. Full walk-through with every screen is in the
**[documentation](https://ensecnet.github.io/netbox-lxc/)**.

## Repository layout

```
netbox-lxc/
├── scripts/
│   ├── netbox-lxc-deploy.sh   # interactive deploy wizard
│   └── netbox-console.sh      # appliance status console + menu
├── docs/                      # documentation site (GitHub Pages)
├── README.md
└── LICENSE
```

## Documentation

The docs site is served from the `docs/` folder via GitHub Pages:

| Page | What's in it |
|------|--------------|
| [Overview](https://ensecnet.github.io/netbox-lxc/) | What it is, one-command start |
| [Deployment walk-through](https://ensecnet.github.io/netbox-lxc/pages/deploy.html) | Step by step from one line to `SUCCESSFUL` |
| [Appliance console](https://ensecnet.github.io/netbox-lxc/pages/console.html) | The status screen and menu |
| [Updates & versions](https://ensecnet.github.io/netbox-lxc/pages/updates.html) | Pinning and the auto-update timer |

## Security note

Generic by design — no real addresses, hostnames or credentials. All examples
use the RFC 5737 documentation range (`192.0.2.0/24`). Secrets entered in the
wizard are written only inside the container, never to this repo.

## License

Apache License 2.0 — see [LICENSE](LICENSE).
