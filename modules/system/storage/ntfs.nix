{
  extraLib,
  pkgs,
  ...
} @ args:
(extraLib.modules.mkModule {
  name = "system.storage.ntfs";
  hasCli = true;
  hasGui = false;
  cliConfig = _: {
    environment.systemPackages = with pkgs; [
      ntfs3g
    ];
  };
})
args
