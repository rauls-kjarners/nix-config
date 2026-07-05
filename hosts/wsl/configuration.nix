{
  config,
  lib,
  pkgs,
  ...
}:

{
  wsl.enable = true;
  wsl.defaultUser = "nixos";
  wsl.interop.register = true;
  wsl.wslConf.network.hostname = "nixos-wsl";

  networking.hostName = "nixos-wsl";

  # Binary caches, trusted users, store optimisation, auto-GC
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-users = [
      "root"
      "nixos"
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
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Rootless podman with docker-compat socket
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  users.users.nixos = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.fish;
    autoSubUidGidRange = true;
  };

  # Enable fish shell
  programs.fish.enable = true;

  # Enable nix-ld for dynamically linked precompiled binaries
  programs.nix-ld.enable = true;

  system.stateVersion = "23.11";
}
