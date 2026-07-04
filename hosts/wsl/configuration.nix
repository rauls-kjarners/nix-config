{ config, lib, pkgs, ... }:

{
  wsl.enable = true;
  wsl.defaultUser = "nixos";
  wsl.interop.register = true;
  wsl.wslConf.network.hostname = "nixos-wsl";

  networking.hostName = "nixos-wsl";

  # Enable Nix Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;


  users.users.nixos = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
    shell = pkgs.fish;
  };

  # Enable fish shell
  programs.fish.enable = true;

  # Enable nix-ld for dynamically linked precompiled binaries
  programs.nix-ld.enable = true;

  system.stateVersion = "23.11";
}
