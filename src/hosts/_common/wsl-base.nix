# Shared WSL Host Configuration
#
# Base system configuration for WSL environments (nixwslbook, nixworkbook).
{
  lib,
  pkgs,
  settings,
  ...
}: {
  # --- Network & Hostname ---
  networking.hostName = settings.hostname;

  # --- NixOS WSL Configuration ---
  wsl = {
    enable = true;
    defaultUser = settings.username;
    wrapBinSh = true;
    extraBin = [
      # Coreutils for remote server compatibility
      {src = "${lib.getExe' pkgs.coreutils "uname"}";}
      {src = "${lib.getExe' pkgs.coreutils "mkdir"}";}
      {src = "${lib.getExe' pkgs.coreutils "cp"}";}
      {src = "${lib.getExe' pkgs.coreutils "cat"}";}
      {src = "${lib.getExe' pkgs.coreutils "ls"}";}
      {src = "${lib.getExe' pkgs.coreutils "rm"}";}
      {src = "${lib.getExe' pkgs.coreutils "mv"}";}
      {src = "${lib.getExe' pkgs.coreutils "chmod"}";}
      {src = "${lib.getExe' pkgs.coreutils "env"}";}
      {src = "${lib.getExe' pkgs.coreutils "dirname"}";}
      {src = "${lib.getExe' pkgs.coreutils "readlink"}";}
      {src = "${lib.getExe' pkgs.coreutils "wc"}";}
      {src = "${lib.getExe' pkgs.coreutils "head"}";}
      {src = "${lib.getExe' pkgs.coreutils "tail"}";}
      {src = "${lib.getExe' pkgs.coreutils "tr"}";}
      # Additional CLI tools
      {src = "${lib.getExe pkgs.gnused}";}
      {src = "${lib.getExe pkgs.gnugrep}";}
      {src = "${lib.getExe pkgs.gnutar}";}
      {src = "${lib.getExe pkgs.gzip}";}
      {src = "${lib.getExe pkgs.findutils}";}
      {src = "${lib.getExe pkgs.wget}";}
      {src = "${lib.getExe pkgs.curl}";}
    ];
    # Re-register WSLInterop to allow executing Windows .exe binaries alongside other binfmt registrations
    interop.register = true;
    docker-desktop.enable = true;
  };

  # --- Profiles & State Version ---
  profiles.system.wsl.enable = true;
  system.stateVersion = lib.mkForce "24.11";
  services.flatpak.packages = lib.mkForce [];

  # --- Headless DBus & User Services ---
  users.users.${settings.username} = {
    linger = true;
  };
  systemd.user.services.dbus.wantedBy = ["default.target"];
  environment.systemPackages = [pkgs.dbus];

  # Auto-start user systemd service at boot (ensures dbus is ready for remote/IDE sessions)
  systemd.services."user@1000" = {
    wantedBy = ["multi-user.target"];
    overrideStrategy = "asDropin";
  };
}
