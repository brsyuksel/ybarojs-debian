# ybarojs-debian

A Debian meta-package providing a complete Wayland desktop environment based on the Sway tiling window manager, featuring custom Catppuccin Mocha themed configurations.

## Overview

**ybarojs-debian** simplifies the installation and configuration of a modern, minimalist Wayland desktop stack on Debian systems. It bundles essential components and applies consistent theming out of the box.

## Features

- **Sway** — A tiling Wayland compositor and drop-in replacement for the i3 window manager
- **Waybar** — Highly customizable Wayland bar for Sway and Wlroots based compositors (Catppuccin Mocha themed)
- **Tofi** — Fast and simple application launcher for Wayland (themed)
- **Greetd + wlgreet** — Minimal and flexible display manager with a Wayland greeter (themed)
- **System-wide Configuration** — All configs installed to `/etc/xdg/` and `/etc/greetd/` for system-wide defaults
- **Automatic Font Installation** — JetBrainsMono Nerd Font and Noto core fonts included
- **Interactive Setup** — User sudo configuration prompt during installation
- **Display Manager Setup** — `_greetd` user automatically added to `video`, `render`, and `input` groups for hardware access

## Dependencies

The following packages are automatically installed:

- `sudo` — User privilege escalation
- `sway` — Tiling Wayland compositor
- `waybar` — Status bar
- `tofi` — Application launcher
- `greetd` — Minimal display manager
- `wlgreet` — Wayland greeter for greetd
- `fonts-jetbrains-mono` — Primary UI font
- `fonts-noto-core` — Unicode coverage fonts
- `wireplumber` — PipeWire session manager
- `pipewire-pulse` — PulseAudio replacement
- `unzip` — Archive extraction utility

## Installation

### Option 1: Quick Install (Recommended)

Use the provided install script to automatically download and install the package:

```bash
wget -qO- https://raw.githubusercontent.com/brsyuksel/ybarojs-debian/main/install.sh | bash
```

Or clone and run locally:

```bash
git clone https://github.com/brsyuksel/ybarojs-debian.git
cd ybarojs-debian
./install.sh
```

### Option 2: Manual Install

Download the `.deb` package from the [releases page](https://github.com/ybaroj/ybarojs-debian/releases) and install:

```bash
sudo dpkg -i ybarojs-debian_*.deb
```

If dependency errors occur, run:

```bash
sudo apt --fix-broken install
```

## Post-Installation

During installation, you will be prompted to configure sudo privileges. The package interactively asks which user should be granted sudo access for the desktop environment.

After installation, the display manager (greetd) will be available. Reboot or start the greetd service to access the graphical login:

```bash
sudo systemctl enable --now greetd
```

## File Locations

Configuration files are installed system-wide for all users:

| Component | Location |
|-----------|----------|
| Sway config | `/etc/xdg/sway/` |
| Waybar config | `/etc/xdg/waybar/` |
| Tofi config | `/etc/xdg/tofi/` |
| Greetd config | `/etc/greetd/` |
| Nerd Fonts | `/usr/share/fonts/` |

User-specific overrides can be placed in `~/.config/` following standard XDG conventions.

## CI/CD

This package is automatically built via GitHub Actions on every push to the main branch. The workflow:

1. Sets up a Debian build environment
2. Generates Debian metadata and control files
3. Packages configuration files into the proper directory structure
4. Builds the `.deb` package
5. Uploads artifacts for release

See `.github/workflows/build.yml` for the complete workflow definition.

## License

This meta-package is released under the MIT License. See [LICENSE](LICENSE) for details.

Individual component configurations (Sway, Waybar, Tofi, Greetd) retain their original licenses where applicable.
