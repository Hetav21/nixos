{
  mkModule,
  lib,
  pkgs,
  ...
} @ args:
(mkModule {
  name = "home.desktop.clipboard";
  hasCli = false;
  hasGui = true;
  guiConfig = _: {
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
