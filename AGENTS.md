# Agentic Debian Package Development

This repository builds a custom Debian meta-package using a multi-agent workflow.

## Agent Roles

**Strategist (Kimi K2.5)** - High-level orchestration
- Define package dependencies (`Depends`, `Recommends`, `Suggests`)
- Map file system hierarchy (FHS) for custom configs
- Generate prompts for worker agents
- Final review before `dpkg-deb --build`

**Packager (Big Pickle / Free)** - Debian metadata
- Generate `debian/control`, `debian/rules`, `debian/changelog`, `debian/copyright`
- Ensure correct `control` file syntax
- Handle versioning strings

**Config Smith (MiniMax M2.5 Free)** - Asset placement
- Wrap dotfiles (Sway, Waybar, Tofi, etc.) into package tree
- Write `debian/install` mapping sources to target paths (`/etc/skel/`, `/etc/xdg/`)
- Generate installation docs

**Guard (Nemotron 3 Super Free)** - Validation
- Pre-build syntax check on `postinst`, `prerm` scripts
- Verify no illegal characters in Debian metadata
- Lintian-style error checks

## Execution Flow

1. User provides package list and raw config files
2. **Strategist** breaks down requirements → file-system map + task list
3. **Packager** builds metadata skeleton; **Config Smith** populates source dirs
4. **Guard** scans for syntax errors
5. **Strategist** approves final `dpkg-deb --build`

## Cost Tiers

| Task | Model Cost | Tier |
|------|------------|------|
| Strategy & Dispatch | $0.60/1M tokens | Paid |
| Boilerplate & Tree | $0.00 | Free |
| Configuration Mapping | $0.00 | Free |
| Syntax Validation | $0.00 | Free |

## Build Commands

```bash
# Build the .deb package
dpkg-deb --build <package-dir>

# Validate package
lintian <package>.deb
```

## Directory Structure Convention

```
<package-name>/
├── debian/
│   ├── control       # Package metadata
│   ├── rules         # Build rules
│   ├── changelog     # Version history
│   ├── copyright     # License info
│   ├── install       # Source-to-destination mapping
│   ├── postinst      # Post-install script (optional)
│   └── prerm         # Pre-remove script (optional)
└── etc/              # Config files to install
    ├── skel/
    └── xdg/
```

## Key Conventions

- Config files go to `/etc/skel/` (user templates) or `/etc/xdg/` (system defaults)
- `debian/install` format: `<source-path> <dest-dir>` (one per line)
- Scripts in `debian/` must be executable and have proper shebang
- Package names use lowercase, hyphens for separators
- Version format: `upstream-version-debian-revision` (e.g., `1.0-1`)
