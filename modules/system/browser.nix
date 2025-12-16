{
  extraLib,
  pkgs,
  pkgs-unstable,
  ...
} @ args:
(extraLib.modules.mkModule {
  name = "system.browser";
  hasCli = false;
  hasGui = true;
  guiConfig = _: {
    environment.systemPackages =
      (with pkgs; [
        custom.browseros
      ])
      ++ (with pkgs-unstable; [
        brave
        google-chrome
      ]);

    services.flatpak.packages = [
      "com.microsoft.Edge"
    ];
  };
})
args
