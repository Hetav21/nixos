{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.home.desktop.hyprshot;
in {
  options.home.desktop.hyprshot = {
    enable = mkEnableOption "Enable hyprshot configuration";
  };

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.settings = {
      bind = [
        # Screenshot a monitor/output
        "CTRL, print, exec, ${pkgs.hyprshot}/bin/hyprshot -m output -o ~/Pictures/Screenshots"

        # Screenshot a region
        "CTRL SHIFT, print, exec, ${pkgs.hyprshot}/bin/hyprshot -m region -o ~/Pictures/Screenshots"
        "SUPER_SHIFT, D, exec, ${pkgs.hyprshot}/bin/hyprshot -m region --clipboard-only"

        # Miscellaneous
        # ''$mainMod, S, exec, ${pkgs.grim} -g "$(${pkgs.slurp})" - | ${pkgs.swappy} -f -''
        # '', print, exec, ${pkgs.grim} $(xdg-user-dir PICTURES)/Screenshots/$(date +'Screenshot_%s.png')''
        # ''CTRL, print, exec, ${pkgs.grim} -g "$(${pkgs.slurp} -o)" $(xdg-user-dir PICTURES)/Screenshots/$(date +'Screenshot_%s.png')''
        # ''CTRL SHIFT, print, exec, ${pkgs.grim} -g "$(${pkgs.slurp})" $(xdg-user-dir PICTURES)/Screenshots/$(date +'Screenshot_%s.png')''
      ];
    };
  };
}
