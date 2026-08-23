{
  extraLib,
  lib,
  pkgs,
  ...
} @ args:
extraLib.modules.mkModule args {
  name = "home.desktop.hyprshot";
  hasCli = false;
  hasGui = true;

  guiConfig = {
    # --- Hyprland Screenshot Keybindings ---
    wayland.windowManager.hyprland.settings = {
      bind = [
        "CTRL, print, exec, ${lib.getExe pkgs.hyprshot} -m output -o ~/Pictures/Screenshots"
        "CTRL SHIFT, print, exec, ${lib.getExe pkgs.hyprshot} -m region -o ~/Pictures/Screenshots"
        "SUPER_SHIFT, D, exec, ${lib.getExe pkgs.hyprshot} -m region --clipboard-only"
      ];
    };
  };
}
