# NixOS Configuration

![CI](https://github.com/rauls-kjarners/nix-config/actions/workflows/ci.yml/badge.svg)

A strict, declarative, modern Nix configuration for macOS and WSL, managed by Nix Flakes, `nix-darwin`, and `home-manager`.

## 🚀 Deployment

Because this is a pure flake, the very first time deploying on a new machine, the system won't have `git` available to evaluate the flake. The `path:` protocol must be used to bypass Git.

### 🐧 WSL (nixos-wsl)

```sh
# First time ever:
sudo nixos-rebuild switch --flake path:.#nixos-wsl

# Subsequent updates:
just update
```

### 🍏 macOS (nix-darwin)

Nix and Homebrew must be installed on the Mac before deploying. Homebrew is required for macOS GUI apps (`homebrew.casks`).

```sh
# First time ever:
darwin-rebuild switch --flake path:.#macbook

# Subsequent updates:
just update
```

## 📂 Architecture

- `hosts/`: OS-level configurations (`nixos-wsl` for Windows, `macbook` for macOS).
- `home/`: OS-agnostic User environment (`home-manager`). Manages all packages, aliases, git, shell plugins, and dotfiles.
- `home/configs/`: The raw dotfiles (WezTerm, Yazi, Zellij, etc.) seamlessly symlinked into `~/.config/` by Home Manager.

## 🤖 Unified System Automation (Justfile)

To provide a seamless, `topgrade`-like experience while adhering to strict Nix developer standards, this repository uses a unified `justfile`:

- **`just update`**: The daily driver. Automatically runs `nix flake update`, rebuilds the NixOS/Darwin system, and finishes with `mise up` to ensure rapidly-iterating AI tools are updated simultaneously.
- **`just setup-nvim`**: Bootstraps the editor environment by cloning the decoupled `nvim-config` repository into `~/Projects` and symlinking it to `~/.config/nvim`.
- **`just fmt`**: Format all Nix files with `nixfmt` (RFC-166 style).
- **`just check`**: Run `nix flake check` — exercises nixfmt, statix, deadnix, and shellcheck via the pre-commit check output.
- **`just clean-nvim`**: Wipes Neovim data and cache directories (`~/.local/share/nvim`, etc.) to quickly fix state corruption, while leaving the config symlink intact.
- **`just bootstrap-ai`**: A one-time command that runs `mise install`, natively loads OMP plugins (`pyright`, `intelephense`), and injects custom AI skills.
- **`just symlink-windows`**: A purely automated Windows bootstrapping command. From WSL, it triggers a native Windows UAC Administrator prompt on the desktop to automatically generate UNC symlinks for WezTerm and Tridactyl (Firefox/Zen Browser).
- **`just install-fonts-windows`**: Automatically reaches into the Windows host, fetches the latest JetBrains Mono Nerd Font from GitHub, and natively installs it into the Windows Registry.

## 🖥️ Host Terminals & Theme Switching

### Windows GUI Apps (WSL Sync)

Nix manages application configurations inside WSL at `~/.config/`. Native Windows GUI applications (like WezTerm and Firefox/Tridactyl) cannot read the WSL filesystem by default.

To effortlessly sync them, run **`just symlink-windows`** from inside WSL. It will pop up a Windows UAC prompt on the desktop and automatically create the required UNC symlinks for WezTerm and Tridactyl.

_Note for Tridactyl Users:_

1. **Native Messenger**: On a fresh install, run `:installnative` in the browser and execute the downloaded script on Windows FIRST. This downloads the required executables. Once installed, run **`just symlink-windows`** to automatically symlink the manifest and `themes/` directory directly to Nix configuration.

   ```powershell
   powershell -ExecutionPolicy Bypass -File "$env:TEMP\tridactyl_installnative.ps1" -Tag 1.24.6
   ```

2. **Apply Custom Theme**: While `just symlink-windows` attempts to sync the `themes/` directory, Tridactyl on Windows often fails to read custom themes via symlinks properly natively. To bypass this, you must apply the custom theme using a direct JSON injection command.
   Open the generated `home/configs/tridactyl/themes/system-theme.md` file, copy the command block, and paste it directly into the Tridactyl command line.

### macOS GUI Apps

macOS is fully POSIX-compliant, meaning Home Manager's native `~/.config` symlinks work perfectly out of the box for GUI applications like Tridactyl and WezTerm.
For Tridactyl, simply run `:installnative` in the browser and paste the provided `curl` command into the terminal. The native messenger will instantly detect the Nix configuration at `~/.config/tridactyl/tridactylrc`. No Windows-style workarounds are required.

### Theme Switching

This setup uses a dual-layer theme switching architecture:

1. **Terminal GUI**: WezTerm has native capabilities to query the host OS (macOS/Windows) for Dark/Light mode and switch its window background colors automatically.
2. **CLI Tools (Neovim, Zellij, Bat, Btop, K9s)**: The `switch_theme dark|light` fish function dynamically rewrites all CLI configs in place. Both platforms drive it:
   - **macOS**: `dark-notify` (installed via `cormacrelf/tap`) runs as a `launchd` user agent; it invokes `switch_theme <mode>` immediately on startup and on every System Settings → Appearance change.
   - **WSL**: Checks the Windows registry (`AppsUseLightTheme`) once on shell startup. For live updates while the shell is running, use the manual `dark` and `light` aliases.
3. **Containers (WSL)**: Rootless podman provides the Docker-compat socket at `$DOCKER_HOST` (`unix:///run/user/<uid>/podman/podman.sock`), powering `lazydocker` and `k9s` without a Docker daemon.

> **macOS cleanup**: If `dark-mode-notify` was previously installed manually at `/opt/homebrew/bin/dark-mode-notify`, it can be removed — `dark-notify` replaces it and is now declared in Homebrew.

## 🔧 Development

```sh
# Install the pre-commit hook (runs nixfmt, statix, deadnix, shellcheck on every commit)
just dev

# Or run checks without entering the shell
just check
```
