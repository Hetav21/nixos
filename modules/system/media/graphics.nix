{extraLib, ...} @ args:
(extraLib.modules.mkModule {
  name = "system.media.graphics";
  hasCli = false;
  hasGui = true;
  guiConfig = _: {
    services.flatpak.packages = [
      "org.gnome.Loupe" # Image viewer
      "com.github.PintaProject.Pinta" # Image editor
      "org.kde.kdenlive" # Video editor
    ];
  };
})
args
