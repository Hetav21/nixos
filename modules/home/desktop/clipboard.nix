{
  extraLib,
  lib,
  pkgs,
  ...
} @ args:
extraLib.modules.mkModule args {
  name = "home.desktop.clipboard";
  hasCli = false;
  hasGui = true;

  guiConfig = {
    # --- Shell Aliases ---
    home.shellAliases = lib.optionalAttrs (pkgs ? wl-clipboard) {
      copy = "${lib.getExe' pkgs.wl-clipboard "wl-copy"}";
      paste = "${lib.getExe' pkgs.wl-clipboard "wl-paste"}";
    };

    # --- Clipboard History Daemon ---
    services.cliphist = {
      enable = true;
      package = pkgs.cliphist;
      allowImages = true;
      systemdTargets = ["hyprland-session.target"];
      extraOptions = ["-max-dedupe-search" "10" "-max-items" "500"];
    };
  };
}
