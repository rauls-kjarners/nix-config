{ config, pkgs, ... }:

{
  # Let nix-darwin manage the Nix installation and daemon.
  nix.enable = true;

  # binary caches, trusted users, store optimisation
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-users = [
      "root"
      "rauls.kjarners"
    ];
    auto-optimise-store = true;
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
  # macOS GC uses launchd interval format, not systemd dates
  nix.gc = {
    automatic = true;
    interval = {
      Weekday = 0;
      Hour = 3;
      Minute = 0;
    };
    options = "--delete-older-than 14d";
  };

  # Workaround for broken darwin-manual-html on nixos-unstable (when nix-darwin
  # does NOT follow nixpkgs). Currently disabled — nix-darwin follows nixpkgs now.
  # If builds break, remove inputs.nixpkgs.follows from flake.nix and uncomment:
  # documentation.enable = false;
  # documentation.doc.enable = false;
  # system.tools.darwin-uninstaller.enable = false;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;
  programs.fish.enable = true;

  users.users."rauls.kjarners" = {
    name = "rauls.kjarners";
    home = "/Users/rauls.kjarners";
    shell = pkgs.fish;
  };

  system.primaryUser = "rauls.kjarners";
  system.stateVersion = 6;

  system.defaults = {
    NSGlobalDomain = {
      KeyRepeat = 2; # Exact Windows max (33ms)
      InitialKeyRepeat = 15; # Exact Windows max (250ms)
    };
  };

  # Native macOS Fonts
  fonts.packages = [
    pkgs.nerd-fonts.jetbrains-mono
  ];

  # Homebrew: declarative, non-destructive (nix-homebrew manages the tap)
  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "none"; # never uninstall undeclared packages
      autoUpdate = false; # deterministic switches
      upgrade = false;
    };
    taps = [
      "buo/cask-upgrade"
      "cormacrelf/tap"
    ];
    brews = [
      "docker-credential-helper"
      "docker-credential-helper-ecr"
      "mas"
      "pngpaste"
      "dark-notify"
    ];
    casks = [
      "appcleaner"
      "betterdisplay"
      "copilot-cli"
      "cyberduck"
      "ghostty"
      "github"
      "google-chrome"
      "homerow"
      "ngrok"
      "obsidian"
      "orbstack"
      "raycast"
      "session-manager-plugin"
      "suspicious-package"
      "visual-studio-code"
      "wezterm@nightly"
    ];
    masApps = {
      "Dimify" = 6758863439;
      "Keynote" = 409183694;
      "Numbers" = 409203825;
      "Pages" = 409201541;
      "The Unarchiver" = 425424353;
    };
  };

  # Replaces bouk/dark-mode-notify (no formula) with cormacrelf/dark-notify.

  # Homebrew 4.4.0+ requires explicitly trusting third-party taps.
  # This activation script runs before the homebrew bundle is evaluated.
  system.activationScripts.trustHomebrewTaps.text = ''
    if [ -x "/opt/homebrew/bin/brew" ]; then
      sudo -H -u "rauls.kjarners" /opt/homebrew/bin/brew trust cormacrelf/tap >/dev/null 2>&1 || true
    fi
  '';
  # dark-notify -c CMD invokes CMD <mode> on startup and on every appearance change.
  launchd.user.agents."dark-notify" = {
    serviceConfig = {
      Label = "com.user.dark-notify";
      KeepAlive = true;
      RunAtLoad = true;
      StandardErrorPath = "/tmp/dark-notify-stderr.log";
      StandardOutPath = "/tmp/dark-notify-stdout.log";
      ProgramArguments = [
        "/opt/homebrew/bin/dark-notify"
        "-c"
        "${pkgs.writeShellScript "theme-notify" ''
          exec /run/current-system/sw/bin/fish -l -c "switch_theme $1"
        ''}"
      ];
    };
  };
}
