{ config, pkgs, ... }:

{
  imports = [ ./default.nix ];

  home.username = "rauls.kjarners";
  home.homeDirectory = "/Users/rauls.kjarners";
}
