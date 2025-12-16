{
  extraLib,
  pkgs,
  pkgs-unstable,
  ...
} @ args:
(extraLib.modules.mkModule {
  name = "system.communication";
  hasCli = false;
  hasGui = true;
  guiConfig = _: {
    environment.systemPackages =
      (with pkgs; [
        zoom-us
      ])
      ++ (with pkgs-unstable; [
        # Communication and social
        thunderbird
        discord
        vesktop
      ]);
  };
})
args
