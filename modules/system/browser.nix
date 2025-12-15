{
  mkModule,
  pkgs,
  pkgs-unstable,
  ...
} @ args:
(mkModule {
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
