# The Unified System Automation Interface

# Default target lists all commands
default:
	@just --list

# Update system and packages
update:
	nix flake update
	@if [ "$(uname)" = "Darwin" ]; then \
		sudo darwin-rebuild switch --flake {{justfile_directory()}}#macbook && \
		brew update && brew upgrade && brew cleanup; \
	elif [ "$(uname)" = "Linux" ]; then \
		sudo nixos-rebuild switch --flake {{justfile_directory()}}#nixos-wsl; \
	fi
	mise up

# Bootstrap Neovim configuration
setup-nvim:
	#!/usr/bin/env bash
	set -e
	echo "Setting up Neovim configuration..."
	if [ ! -d "{{justfile_directory()}}/../nvim-config" ]; then
		git clone https://github.com/rauls-kjarners/nvim-config.git "{{justfile_directory()}}/../nvim-config"
	else
		echo "Repo already exists at {{justfile_directory()}}/../nvim-config"
	fi

	# Safely remove existing symlink or backup existing folder
	if [ -L "$HOME/.config/nvim" ]; then
		rm "$HOME/.config/nvim"
	elif [ -d "$HOME/.config/nvim" ]; then
		mv "$HOME/.config/nvim" "$HOME/.config/nvim.bak"
	fi

	ln -s "{{justfile_directory()}}/../nvim-config" "$HOME/.config/nvim"
	echo "Neovim config cloned and symlinked!"

# Bootstrap development environment
bootstrap-ai:
	mise install
	mise exec -- omp plugin install omp.nvim
	mkdir -p ~/.omp/skills ~/.omp/agent/skills
	mise exec -- skills add mattpocock/skills@grill-me -a pi -g -y
	mise exec -- skills add juliusbrussee/caveman@caveman -a pi -g -y

# Install Windows native symlinks
symlink-windows:
	#!/usr/bin/env bash
	echo "Triggering Windows UAC Prompt to create native symlinks..."
	powershell.exe -NoProfile -Command "Start-Process powershell -Verb RunAs -ArgumentList '-NoProfile -Command \"New-Item -ItemType SymbolicLink -Path ''\$env:USERPROFILE\.wezterm.lua'' -Target ''\\\\wsl.localhost\\NixOS\\home\\nixos\\Projects\\nix-config\\home\\configs\\wezterm\\wezterm.lua'' -Force; New-Item -ItemType SymbolicLink -Path ''\$env:USERPROFILE\.mozilla\\native-messaging-hosts\\tridactyl.json'' -Target ''\\\\wsl.localhost\\NixOS\\home\\nixos\\Projects\\nix-config\\home\\configs\\tridactyl\\tridactyl.json'' -Force; Write-Host ''Symlinks created successfully! Press any key to close...''; \$null = \$Host.UI.RawUI.ReadKey(''NoEcho,IncludeKeyDown'')\"'"

# Download and install JetBrains Mono Nerd Font natively on Windows
install-fonts-windows:
	#!/usr/bin/env bash
	echo "Fetching latest JetBrains Mono Nerd Font release from GitHub..."
	powershell.exe -NoProfile -Command '
		$ErrorActionPreference = "Stop";
		$tag = (Invoke-RestMethod https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest).tag_name;
		$url = "https://github.com/ryanoasis/nerd-fonts/releases/download/$tag/JetBrainsMono.zip";
		Write-Host "Downloading $url...";
		$TempDir = Join-Path $env:TEMP "JetBrainsMonoTemp";
		New-Item -ItemType Directory -Path $TempDir -Force | Out-Null;
		Invoke-WebRequest -Uri $url -OutFile "$TempDir\JetBrainsMono.zip";
		Write-Host "Extracting fonts...";
		Expand-Archive -Path "$TempDir\JetBrainsMono.zip" -DestinationPath "$TempDir\Fonts" -Force;
		Write-Host "Installing to Windows Registry (may require a moment)...";
		$shell = New-Object -ComObject Shell.Application;
		$fontFolder = $shell.Namespace(0x14);
		foreach ($font in Get-ChildItem -Path "$TempDir\Fonts" -Filter "*.ttf") {
			$fontFolder.CopyHere($font.FullName, 16)
		};
		Remove-Item -Recurse -Force $TempDir;
		Write-Host "Fonts installed successfully!"
	'

# Format all Nix files
fmt:
	cd {{justfile_directory()}} && nix fmt .

# Run flake checks (formatting, statix, deadnix, shellcheck, pre-commit)
check:
	cd {{justfile_directory()}} && nix flake check

# Enter dev shell (installs the git pre-commit hook on first entry)
dev:
	cd {{justfile_directory()}} && nix develop

# Garbage-collect generations older than 14 days
gc:
	nix-collect-garbage --delete-older-than 14d

# Wipe Neovim data and cache directories (fixes LazyVim/LSP corruption)
clean-nvim:
	#!/usr/bin/env bash
	echo "Removing Neovim data and cache directories..."
	rm -rf ~/.local/share/nvim
	rm -rf ~/.local/state/nvim
	rm -rf ~/.cache/nvim
	echo "Neovim state wiped! (Your ~/.config/nvim remains intact)"
