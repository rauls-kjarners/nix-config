{ config, pkgs, ... }:

{
  imports = [ ./default.nix ];

  home.username = "nixos";
  home.homeDirectory = "/home/nixos";

  # Bridge to Windows OneDrive for Obsidian (WSL-only)
  home.file."OneDrive/vaults".source =
    config.lib.file.mkOutOfStoreSymlink "/mnt/c/Users/rauls/OneDrive/vaults";

}
