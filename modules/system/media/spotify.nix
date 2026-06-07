{extraLib, ...} @ args:
(extraLib.modules.mkModule {
  name = "system.media.spotify";
  hasCli = false;
  hasGui = true;
  guiConfig = _: {
    services.flatpak.packages = [
      "com.spotify.Client" # Music streaming
    ];
  };
})
args
