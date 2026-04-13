# ybaroj-sway-wm Configuration Files

This directory contains the source configuration files for the `ybaroj-sway-wm` Debian package.

## Directory Structure

The following configuration directories are mapped to their destination paths via `debian/install`:

| Source Directory | Destination Path | Purpose |
|------------------|------------------|---------|
| `../etc/skel/.config/sway/` | `/etc/skel/.config/sway/` | Sway window manager configuration |
| `../etc/skel/.config/waybar/` | `/etc/skel/.config/waybar/` | Waybar status bar configuration |
| `../etc/skel/.config/tofi/` | `/etc/skel/.config/tofi/` | Tofi application launcher configuration |
| `../etc/skel/.config/mako/` | `/etc/skel/.config/mako/` | Mako notification daemon configuration |
| `../etc/skel/.config/foot/` | `/etc/skel/.config/foot/` | Foot terminal emulator configuration |
| `../etc/xdg/greetd/` | `/etc/xdg/greetd/` | Greetd display manager configuration |

## Expected Config Files

### Sway (`etc/skel/.config/sway/`)
- `config` - Main Sway configuration file
- `keybindings` (optional) - Custom keybindings file

### Waybar (`etc/skel/.config/waybar/`)
- `config` - Waybar configuration
- `style.css` - Custom stylesheet

### Tofi (`etc/skel/.config/tofi/`)
- `config` - Tofi launcher configuration

### Mako (`etc/skel/.config/mako/`)
- `config` - Mako notification configuration

### Foot (`etc/skel/.config/foot/`)
- `foot.ini` - Foot terminal configuration

### Greetd (`etc/xdg/greetd/`)
- `config.toml` - Greetd display manager configuration

## Installation

During package installation, these files are copied to `/etc/skel/` (user template files) or `/etc/xdg/` (system defaults). New users created after package installation will receive these configuration files in their home directories.
