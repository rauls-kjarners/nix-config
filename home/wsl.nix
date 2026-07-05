{ config, pkgs, ... }:

{
  imports = [ ./default.nix ];

  home.username = "nixos";
  home.homeDirectory = "/home/nixos";

  # Bridge to Windows OneDrive for Obsidian (WSL-only)
  home.file."OneDrive/vaults".source =
    config.lib.file.mkOutOfStoreSymlink "/mnt/c/Users/rauls/OneDrive/vaults";

  # Rootless podman API socket (DOCKER_HOST in config.fish targets this)
  systemd.user.sockets.podman = {
    Unit.Description = "Podman API socket (rootless)";
    Socket = {
      ListenStream = "%t/podman/podman.sock";
      SocketMode = "0660";
    };
    Install.WantedBy = [ "sockets.target" ];
  };
  systemd.user.services.podman = {
    Unit.Description = "Podman API service (rootless)";
    Service = {
      Type = "exec";
      ExecStart = "${pkgs.podman}/bin/podman system service --time=0";
    };
  };

}
