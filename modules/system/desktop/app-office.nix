{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.system.desktop.office;
in {
  options.system.desktop.office = {
    enable = mkEnableOption "Enable office applications configuration";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      # File management and archives
      xfce.thunar
      file-roller

      # Audio and video
      pavucontrol
      obs-studio
      mpv
      yt-dlp

      # Image and graphics
      upscayl

      # Productivity and office
      unstable.obsidian
      texliveMinimal
    ];

    services.flatpak.packages = [
      "org.gnome.Loupe"
      "org.kde.kdenlive"
      "com.github.PintaProject.Pinta"
      "org.libreoffice.LibreOffice"
      "org.onlyoffice.desktopeditors"
      "org.texstudio.TeXstudio"
      "com.github.IsmaelMartinez.teams_for_linux"
    ];

    programs = {
      thunar = {
        enable = true;
        plugins = with pkgs.xfce; [thunar-archive-plugin thunar-volman];
      };
    };
  };
}
