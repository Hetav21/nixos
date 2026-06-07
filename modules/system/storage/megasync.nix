{
  extraLib,
  pkgs,
  ...
} @ args:
(extraLib.modules.mkModule {
  name = "system.storage.megasync";
  hasCli = false;
  hasGui = true;
  guiConfig = _: {
    environment.systemPackages = with pkgs; [
      megasync
      megacmd
    ];
  };
})
args
