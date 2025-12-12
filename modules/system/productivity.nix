{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.system.productivity;
in {
  options.system.productivity = {
    enableGui = mkEnableOption "Enable GUI productivity tools (office, file managers)";
  };

  config = mkIf cfg.enableGui {
    environment.systemPackages = with pkgs; [
      # File management
      xfce.thunar
      file-roller

      # Productivity
      texliveMinimal
      obsidian
    ];

    services.flatpak.packages = [
      "org.libreoffice.LibreOffice"
      "org.onlyoffice.desktopeditors"
      "org.texstudio.TeXstudio"
      "com.github.IsmaelMartinez.teams_for_linux"
    ];

    programs.thunar = {
      enable = true;
      plugins = with pkgs.xfce; [thunar-archive-plugin thunar-volman];
    };
  };
}
