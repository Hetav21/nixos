{
  extraLib,
  lib,
  pkgs,
  ...
} @ args:
(extraLib.modules.mkModule {
  name = "home.desktop.hyprshot";
  hasCli = false;
  hasGui = true;
  guiConfig = _: {
    wayland.windowManager.hyprland.settings = {
      bind = [
        # Screenshot a monitor/output
        "CTRL, print, exec, ${lib.getExe pkgs.hyprshot} -m output -o ~/Pictures/Screenshots"

        # Screenshot a region
        "CTRL SHIFT, print, exec, ${lib.getExe pkgs.hyprshot} -m region -o ~/Pictures/Screenshots"
        "SUPER_SHIFT, D, exec, ${lib.getExe pkgs.hyprshot} -m region --clipboard-only"

        # Miscellaneous
        # ''$mainMod, S, exec, ${pkgs.grim} -g "$(${pkgs.slurp})" - | ${pkgs.swappy} -f -''
        # '', print, exec, ${pkgs.grim} $(xdg-user-dir PICTURES)/Screenshots/$(date +'Screenshot_%s.png')''
        # ''CTRL, print, exec, ${pkgs.grim} -g "$(${pkgs.slurp} -o)" $(xdg-user-dir PICTURES)/Screenshots/$(date +'Screenshot_%s.png')''
        # ''CTRL SHIFT, print, exec, ${pkgs.grim} -g "$(${pkgs.slurp})" $(xdg-user-dir PICTURES)/Screenshots/$(date +'Screenshot_%s.png')''
      ];
    };
  };
})
args
