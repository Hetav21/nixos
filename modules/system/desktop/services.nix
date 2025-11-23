{
  lib,
  pkgs,
  config,
  settings,
  ...
}:
with lib; let
  cfg = config.system.desktop.services;
in {
  options.system.desktop.services = {
    enable = mkEnableOption "Enable desktop services configuration";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      # Shell and terminal utilities
      killall
      most
      vim

      # System monitoring and management
      btop

      # System utilities

      # File systems
      ntfs3g
    ];

    services = {
      # Nix-Flatpak
      flatpak = {
        enable = true;
        uninstallUnmanaged = true;
        update.auto = {
          enable = true;
          onCalendar = "daily";
        };
        packages = [
          "io.github.flattool.Warehouse"
          "com.github.tchx84.Flatseal"
        ];
      };

      preload.enable = true;

      locate = {
        enable = true;
        package = pkgs.mlocate;
      };

      cron = {enable = true;};
    };

    users.users.${settings.username}.extraGroups = ["mlocate"];

    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };
}
