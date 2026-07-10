# NixOS Configuration

![CI](https://github.com/rauls-kjarners/nix-config/actions/workflows/ci.yml/badge.svg)

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

## 📂 Architecture

- `hosts/`: OS-level configurations (`nixos-wsl` for Windows, `macbook` for macOS).
- `home/`: OS-agnostic User environment (`home-manager`). Manages all packages, aliases, git, shell plugins, and dotfiles.
- `home/configs/`: The raw dotfiles (`nvim`, `wezterm`, `yazi`, `zellij`) that are seamlessly symlinked into `~/.config/` by Home Manager.

## 🤖 Unified System Automation (Justfile)

To provide a seamless, `topgrade`-like experience while adhering to strict Nix developer standards, this repository uses a unified `justfile`:

- **`just update`**: The daily driver. Automatically runs `nix flake update`, rebuilds your NixOS/Darwin system, and finishes with `mise up` to ensure rapidly-iterating AI tools are updated simultaneously.
- **`just fetch-zj-plugins`**: Download Zellij WASM plugins locally (avoids tracking binaries in Git).
- **`just fmt`**: Format all Nix files with `nixfmt` (RFC-166 style).
- **`just check`**: Run `nix flake check` — exercises nixfmt, statix, deadnix, and shellcheck via the pre-commit check output.
- **`just dev`**: Enter the dev shell; installs the git pre-commit hook on first entry so hooks run automatically on every `git commit`.
- **`just clean-nvim`**: Wipes Neovim data and cache directories (`~/.local/share/nvim`, etc.) to quickly fix LSP/Mason corruption, while leaving your config symlink intact.
- **`just gc`**: Garbage-collect Nix store generations older than 14 days.
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
2. **CLI Tools (Neovim, Zellij, Bat, Btop, K9s)**: The `switch_theme dark|light` fish function dynamically rewrites all CLI configs in place. Both platforms drive it automatically:
   - **macOS**: `dark-notify` (installed via `cormacrelf/tap`) runs as a `launchd` user agent; it invokes `switch_theme <mode>` immediately on startup and on every System Settings → Appearance change.
   - **WSL**: A systemd user timer (`theme-sync`) polls the Windows registry (`AppsUseLightTheme`) every 10 seconds and calls `switch_theme` when the mode changes. No manual intervention needed.
3. **Containers (WSL)**: Rootless podman provides the Docker-compat socket at `$DOCKER_HOST` (`unix:///run/user/<uid>/podman/podman.sock`), powering `lazydocker` and `k9s` without a Docker daemon.

> **macOS cleanup**: If you previously installed `dark-mode-notify` manually at `/opt/homebrew/bin/dark-mode-notify`, it can be removed — `dark-notify` replaces it and is now declared in Homebrew.

## 🔧 Development

```sh
# Install the pre-commit hook (runs nixfmt, statix, deadnix, shellcheck on every commit)
just dev

# Or run checks without entering the shell
just check
```
