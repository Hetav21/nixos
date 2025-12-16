{
  extraLib,
  lib,
  pkgs,
  ...
} @ args:
(extraLib.modules.mkModule {
  name = "system.desktop.appimage";
  hasGui = false;
  cliConfig = _: {
    environment.systemPackages = with pkgs; [appimage-run];

    programs.fuse.userAllowOther = true;

    programs.appimage = {
      enable = true;
      binfmt = true;
    };
  };
})
args
