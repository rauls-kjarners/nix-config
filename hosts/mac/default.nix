{ config, pkgs, ... }:

{
  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;

  # Enable Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  nixpkgs.config.allowUnfree = true;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;
  programs.fish.enable = true;

  networking.hostName = "macbook";
  networking.computerName = "macbook";

  users.users."rauls.kjarners" = {
    name = "rauls.kjarners";
    home = "/Users/rauls.kjarners";
    shell = pkgs.fish;
  };

  system.stateVersion = 4;

  # Native macOS Fonts
  fonts.packages = [
    pkgs.nerd-fonts.jetbrains-mono
  ];

  # Homebrew for macOS specific native apps
  homebrew = {
    enable = true;
    brews = [
      "pngpaste"
    ];
    casks = [
      # Add any macOS GUI applications here (e.g., "raycast", "spotify")
    ];
    onActivation.cleanup = "zap";
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
