{
  extraLib,
  pkgs,
  settings,
  ...
} @ args:
(extraLib.modules.mkModule {
  name = "system.baseservices";
  hasGui = true;
  cliConfig = {
    pkgs,
    settings,
    ...
  }: {
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
  };
  guiConfig = _: {
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
  };
})
args
