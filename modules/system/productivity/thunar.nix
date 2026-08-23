{
  extraLib,
  pkgs,
  ...
} @ args:
extraLib.modules.mkModule args {
  name = "system.productivity.thunar";
  hasCli = false;
  hasGui = true;
  guiConfig = {
    # --- Packages ---
    environment.systemPackages = [
      pkgs.thunar
      pkgs.file-roller
    ];

    # --- Programs ---
    programs.thunar = {
      enable = true;
      plugins = [
        pkgs.thunar-archive-plugin
        pkgs.thunar-volman
      ];
    };
  };
}
