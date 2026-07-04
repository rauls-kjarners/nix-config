{ config, pkgs, ... }:

{
  imports = [ ./default.nix ];

  home.username = "nixos";
  home.homeDirectory = "/home/nixos";
}
