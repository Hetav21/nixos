{
  lib,
  pkgs,
  config,
  settings,
  ...
}:
with lib; let
  cfg = config.system.baseservices;
in {
  options.system.baseservices = {
    enable = mkEnableOption "Enable base CLI/TUI system services and utilities";
    enableGui = mkEnableOption "Enable GUI system services (flatpak)";
  };

  config = mkMerge [
    # Base CLI/TUI services and utilities
    (mkIf cfg.enable {
      services = {
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
    })

    # GUI services
    (mkIf cfg.enableGui {
      # Auto-enable base services
      system.baseservices.enable = true;

      services.flatpak = {
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
    })
  ];
}
