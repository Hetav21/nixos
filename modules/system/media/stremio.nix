{extraLib, ...} @ args:
(extraLib.modules.mkModule {
  name = "system.media.stremio";
  hasCli = false;
  hasGui = true;
  guiConfig = _: {
    services.flatpak.packages = [
      "com.stremio.Stremio" # Video streaming
    ];
  };
})
args
