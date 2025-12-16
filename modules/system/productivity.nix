{
  extraLib,
  pkgs,
  ...
} @ args:
(extraLib.modules.mkModule {
  name = "system.productivity";
  hasCli = false;
  hasGui = true;
  guiConfig = _: {
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
})
args
