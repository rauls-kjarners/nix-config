# NixOS Configuration

A strict, declarative, modern Nix configuration for macOS and WSL, managed by Nix Flakes, `nix-darwin`, and `home-manager`.

## 🚀 Deployment

Because this is a pure flake, the very first time you deploy on a new machine, your system won't have `git` available to evaluate the flake. You must use the `path:` protocol to bypass Git.

### 🐧 WSL (nixos-wsl)

```sh
# First time ever:
sudo nixos-rebuild switch --flake path:.#nixos-wsl

# Subsequent updates:
just update
```

### 🍏 macOS (nix-darwin)

You must have Nix and Homebrew installed on your Mac before deploying. Homebrew is required for macOS GUI apps (`homebrew.casks`).

```sh
# First time ever:
darwin-rebuild switch --flake path:.#macbook

# Subsequent updates:
just update
```

_Note: The automatic macOS theme-switcher expects `dark-mode-notify` to be installed at `/opt/homebrew/bin/dark-mode-notify`. Please ensure it is installed, otherwise the background service will silently fail._

## 📂 Architecture

- `hosts/`: OS-level configurations (`nixos-wsl` for Windows, `macbook` for macOS).
- `home/`: OS-agnostic User environment (`home-manager`). Manages all packages, aliases, git, shell plugins, and dotfiles.
- `home/configs/`: The raw dotfiles (`nvim`, `wezterm`, `yazi`, `zellij`) that are seamlessly symlinked into `~/.config/` by Home Manager.

## 🤖 Unified System Automation (Justfile)

To provide a seamless, `topgrade`-like experience while adhering to strict Nix developer standards, this repository uses a unified `justfile`:

- **`just update`**: The daily driver. Automatically runs `nix flake update`, rebuilds your NixOS/Darwin system, and finishes with `mise up` to ensure rapidly-iterating AI tools are updated simultaneously.
- **`just bootstrap-ai`**: A one-time command that runs `mise install`, natively loads your OMP plugins (`pyright`, `intelephense`), and injects your custom AI skills.
- **`just symlink-windows`**: A purely automated Windows bootstrapping command. From WSL, it triggers a native Windows UAC Administrator prompt on your desktop to automatically generate the complex UNC symlinks for WezTerm and Zen Browser!
- **`just install-fonts-windows`**: Automatically reaches into the Windows host, fetches the latest JetBrains Mono Nerd Font from GitHub, and natively installs it into the Windows Registry.

## 🖥️ Host Terminals & Theme Switching

### Windows GUI Apps (WSL Sync)

Nix manages your application configurations inside WSL at `~/.config/`. Native Windows GUI applications (like WezTerm and Firefox/Tridactyl) cannot read the WSL filesystem by default.

To effortlessly sync them, run **`just symlink-windows`** from inside WSL. It will pop up a Windows UAC prompt on your desktop and automatically create the required UNC symlinks for WezTerm and Tridactyl.

_Note for Tridactyl Users:_

1. **Native Messenger**: After running the justfile symlink, run `:installnative` in the browser and execute the downloaded script on Windows (bypassing execution policies if necessary):

   ```powershell
   powershell -ExecutionPolicy Bypass -File "$env:TEMP\tridactyl_installnative.ps1" -Tag 1.24.6
   ```

2. **Apply Custom Theme (Firefox/Zen Browser Workaround)**: Firefox/Zen Browser (Windows) often fails to load local custom CSS themes because it ignores standard Mozilla registry paths. To ensure your `system` colorscheme works, run `:set customthemes` to open Tridactyl Preferences, and paste the contents of `home\configs\tridactyl\themes\system.css` as a JSON dictionary into the `customthemes` setting box:

   ```json
   { "system": ":root { ... }" }
   ```

### macOS GUI Apps

macOS is fully POSIX-compliant, meaning Home Manager's native `~/.config` symlinks work perfectly out of the box for GUI applications like Tridactyl and WezTerm.

For Tridactyl, simply run `:installnative` in the browser and paste the provided `curl` command into your terminal. The native messenger will instantly detect your Nix configuration at `~/.config/tridactyl/tridactylrc`. No Windows-style workarounds are required!

### Theme Switching

This setup uses a dual-layer theme switching architecture:

1. **Terminal GUI**: WezTerm has native capabilities to query the host OS (macOS/Windows) for Dark/Light mode and switch its window background colors automatically.
2. **CLI Tools (Neovim, Zellij, Bat)**: On macOS, the `dark-mode-notify` daemon listens for OS-level theme changes and automatically triggers the `switch_theme.fish` script. This script dynamically injects the correct hex colors into your running CLI multiplexers and editors without requiring a terminal restart. On Windows, you can trigger this script manually inside WSL, or bind it to a shortcut.
