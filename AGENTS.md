# Agentic Debian Package Development

This repository builds a custom Debian meta-package using a multi-agent workflow.

## Agent Roles

**Lead Strategist (Kimi K2.5)** - *The Architect*
- High-level orchestration and project roadmap.
- Final decision maker on package dependencies and system integration.
- Generates context-rich prompts for specialized worker agents.

**Technical Counsel (Hy3 Preview)** - *The Policy Expert*
- Cross-checks decisions against Debian Policy Manual & FHS.
- Handles complex reasoning tasks (e.g., resolving circular dependencies).
- Refines `debian/rules` and systemd integration logic.

**Fast Operator (Ling 2.6 Flash)** - *The Speedster*
- Rapid generation of boilerplate files (`changelog`, `copyright`).
- Automates "Config Mapping": Parsing dotfiles and generating `debian/install`.
- High-speed path refactoring (e.g., rewriting config paths for `/etc/xdg`).

**Packager (Big Pickle)** - *The Metadata Smith*
- Ensures strict `debian/control` syntax.
- Manages versioning strings and maintainer metadata.

**Guard (Nemotron 3 Super)** - *The Validator*
- Pre-build syntax check on `postinst`, `prerm` scripts.
- Lintian-style error detection and security auditing.

## Execution Flow

1. **Vision:** **Strategist** defines the requirements and file-system map.
2. **Review:** **Counsel** validates the map against Debian standards.
3. **Execution:** **Fast Operator** generates the file tree and mapping; **Packager** creates metadata.
4. **Audit:** **Guard** scans for syntax and policy violations.
5. **Approval:** **Strategist** performs final review for `dpkg-deb --build`.

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
