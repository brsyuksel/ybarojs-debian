# ybaroj-sway-wm Configuration Files

This directory contains the source configuration files for the `ybaroj-sway-wm` Debian package.

## Directory Structure

The following configuration directories are mapped to their destination paths via `debian/install`:

| Source Directory | Destination Path | Purpose |
|------------------|------------------|---------|
| `../etc/xdg/sway/` | `/etc/xdg/sway/` | System-wide Sway window manager configuration |
| `../etc/xdg/waybar/` | `/etc/xdg/waybar/` | System-wide Waybar status bar configuration |
| `../etc/xdg/tofi/` | `/etc/xdg/tofi/` | System-wide Tofi application launcher configuration |
| `../etc/greetd/` | `/etc/greetd/` | Greetd display manager configuration |

## Expected Config Files

### Sway (`etc/xdg/sway/`)
- `config` - Main Sway configuration file
- `keybindings` (optional) - Custom keybindings file

### Waybar (`etc/xdg/waybar/`)
- `config` - Waybar configuration
- `style.css` - Custom stylesheet

### Tofi (`etc/xdg/tofi/`)
- `config` - Tofi launcher configuration

### Greetd (`etc/greetd/`)
- `config.toml` - Greetd display manager configuration

## Installation

During package installation, these files are copied to system-wide configuration directories:
- `/etc/xdg/` - System defaults for XDG-compliant applications (Sway, Waybar, Tofi)
- `/etc/greetd/` - Greetd display manager configuration

These configuration files are applied system-wide for all users. Individual users can override these settings by creating their own configurations in `~/.config/`. Applications will search for configs in the following order:
1. User config: `~/.config/<app>/`
2. System config: `/etc/xdg/<app>/`
