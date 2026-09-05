{
  extraLib,
  pkgs,
  ...
} @ args:
extraLib.modules.mkModule args {
  name = "home.shell.terminals";
  hasCli = false;
  hasGui = true;
  guiConfig = {
    # --- Terminal Emulators ---
    programs = {
      ghostty = {
        enable = true;
        package = pkgs.unstable.ghostty;
      };
    };
  };
}
