{
  extraLib,
  pkgs-unstable,
  ...
} @ args:
extraLib.modules.mkModule args {
  name = "home.shell.terminals";
  hasCli = false;
  hasGui = true;
  guiConfig = {
    # --- Terminal Emulators ---
    programs = {
      alacritty = {
        enable = true;
        package = pkgs-unstable.alacritty;
      };

      ghostty = {
        enable = true;
        package = pkgs-unstable.ghostty;
      };
    };
  };
}
