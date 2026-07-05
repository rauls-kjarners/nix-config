{ config, pkgs, ... }:

{
  # Let nix-darwin manage the Nix installation and daemon.
  nix.enable = true;
  nix.package = pkgs.nix;

  # Enable Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  nixpkgs.config.allowUnfree = true;

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

  # Native macOS Fonts
  fonts.packages = [
    pkgs.nerd-fonts.jetbrains-mono
  ];

  # Homebrew: declarative, non-destructive (nix-homebrew manages the tap)
  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "none";     # never uninstall undeclared packages
      autoUpdate = false;   # deterministic switches
      upgrade = false;
    };
    taps = [
      "dimentium/autoraise"
      "buo/cask-upgrade"
      "github/gh"
    ];
    brews = [
      "docker-credential-helper"
      "docker-credential-helper-ecr"
      "mas"
      "pngpaste"
    ];
    casks = [
      "appcleaner"
      "autoraiseapp"
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
      "zed"
    ];
    masApps = {
      "Dimify"         = 6758863439;
      "Keynote"        = 409183694;
      "Numbers"        = 409203825;
      "Pages"          = 409201541;
      "The Unarchiver" = 425424353;
    };
  };

  # Auto-switch terminal theme when macOS dark mode changes
  launchd.user.agents."dark-mode-notify" = {
    serviceConfig = {
      Label = "com.user.dark-mode-notify";
      KeepAlive = true;
      StandardErrorPath = "/tmp/dark-mode-notify-stderr.log";
      StandardOutPath = "/tmp/dark-mode-notify-stdout.log";
      ProgramArguments = [
        "/opt/homebrew/bin/dark-mode-notify"
        "/run/current-system/sw/bin/fish"
        "-c"
        "if test \"$DARKMODE\" = 1; switch_theme dark; else; switch_theme light; end"
      ];
      RunAtLoad = true;
    };
  };
}
