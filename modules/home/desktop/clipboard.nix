{
  extraLib,
  lib,
  pkgs,
  ...
} @ args:
(extraLib.modules.mkModule {
  name = "home.desktop.clipboard";
  hasCli = false;
  hasGui = true;
  guiConfig = _: {
    home.shellAliases = lib.optionalAttrs (pkgs ? wl-clipboard) {
      copy = "${lib.getExe' pkgs.wl-clipboard "wl-copy"}";
      paste = "${lib.getExe' pkgs.wl-clipboard "wl-paste"}";
    };

    services.cliphist = {
      enable = true;
      package = pkgs.cliphist;
      allowImages = true;
      systemdTargets = ["hyprland-session.target"];
      extraOptions = ["-max-dedupe-search" "10" "-max-items" "500"];
    };
  };
})
args
