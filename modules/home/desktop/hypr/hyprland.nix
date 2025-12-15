{
  mkModule,
  lib,
  pkgs,
  config,
  ...
} @ args:
(mkModule {
  name = "home.desktop.hyprland";
  hasCli = false;
  hasGui = true;
  guiConfig = _: {
    wayland.windowManager.hyprland = {
      enable = true;
      package = pkgs.hyprland;
      portalPackage = pkgs.xdg-desktop-portal-hyprland;
      sourceFirst = true;
      xwayland.enable = true;
      systemd = {
        enable = true;
        enableXdgAutostart = true;
        variables = ["--all"];
      };

      settings = {
        debug = {disable_logs = true;};

        ecosystem = {no_update_news = true;};

        cursor = {no_hardware_cursors = true;};

        xwayland = {
          force_zero_scaling = true;
          use_nearest_neighbor = true;
        };

        input = {kb_options = "ctrl:nocaps";};

        general = {
          border_size = 1;
          resize_on_border = true;
          allow_tearing = false;
        };

        animations = {
          enabled = "yes";

          bezier = [
            "easeOutQuint,0.23,1,0.32,1"
            "easeInOutCubic,0.65,0.05,0.36,1"
            "linear,0,0,1,1"
            "almostLinear,0.5,0.5,0.75,1.0"
            "quick,0.15,0,0.1,1"
          ];

          animation = [
            "global, 1, 10, default"
            "border, 1, 5.39, easeOutQuint"
            "windows, 1, 4.79, easeOutQuint"
            "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
            "windowsOut, 1, 1.49, linear, popin 87%"
            "fadeIn, 1, 1.73, almostLinear"
            "fadeOut, 1, 1.46, almostLinear"
            "fade, 1, 3.03, quick"
            "layers, 1, 3.81, easeOutQuint"
            "layersIn, 1, 4, easeOutQuint, fade"
            "layersOut, 1, 1.5, linear, fade"
            "fadeLayersIn, 1, 1.79, almostLinear"
            "fadeLayersOut, 1, 1.39, almostLinear"
            "workspaces, 1, 1.94, almostLinear, fade"
            "workspacesIn, 1, 1.21, almostLinear, fade"
            "workspacesOut, 1, 1.94, almostLinear, fade"
          ];
        };

        decoration = {
          rounding = 10;
          rounding_power = 2;
          blur = {
            enabled = true;
            size = 3;
            passes = 1;
            vibrancy = 0.1696;
          };
        };

        misc = {
          force_default_wallpaper = 0;
          disable_hyprland_logo = true;
        };
      };
      extraConfig =
        ''
          env = HYPRCURSOR_SIZE,24
        ''
        + ''
          general:resize_on_border = true;
          general:allow_tearing = false;
        ''
        + ''
          windowrulev2 = nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0
          windowrulev2 = suppressevent maximize, class:.*

          windowrulev2 = opacity 0.95 0.95,class:^(firefox-nightly)$
          windowrulev2 = opacity 0.95 0.95,class:^(firefox)$
          windowrulev2 = opacity 0.95 0.95,class:^(zen)$
          windowrulev2 = opacity 0.95 0.95,class:^(dev.zed.Zed)$
          windowrulev2 = opacity 0.95 0.95,class:^(obsidian)$
          windowrulev2 = opacity 0.95 0.95,class:^(intellij-idea-ultimate-edition)$
        ''
        + ''
          # Main modifier
          $mainMod = SUPER # windows key

          # Binds

          ## Browser
          $brave = brave
          $browser = zen-beta
          $browser_alternate = browseros
          bind = $mainMod, F, exec, $browser
          bind = SUPER_SHIFT, F, exec, $browser_alternate
          bind = $mainMod, B, exec, $brave
          bind = $mainMod, V, exec, $browser --new-window https://chat.deepseek.com/
          bind = SUPER_SHIFT, V, exec, $browser --new-window http://localhost:8080/
          bind = $mainMod, G, exec, $browser --new-window https://gemini.google.com/
          bind = SUPER_SHIFT, G, exec, $browser --new-window https://chatgpt.com/
          bind = SUPER_SHIFT, C, exec, $browser --new-window https://claude.ai/
          bind = $mainMod, L, exec, $browser --new-window https://leetcode.com/problemset/

          ## Editor and Terminal
          $term = ghostty
          $termNew = $term -e
          $code = code
          $zeditor = zeditor
          bind = $mainMod, Z, exec, $zeditor
          bind = $mainMod, X, exec, $code
          bind = $mainMod, T, exec, $term
          bind = SUPER_SHIFT, T, exec, $termNew tmux attach

          ## Misc
          $fileManager = $termNew yazi
          $fileManager2 = thunar
          bind = $mainMod, N, exec, $fileManager
          bind = SUPER_SHIFT, N, exec, $fileManager2

          ## Functionality
          bind = $mainMod, W, togglefloating,
          bind = SUPER_SHIFT, Q, killactive,
          bind = SUPER_SHIFT, M, exit,
          bind = Alt, Return, fullscreen,
          # bind = $mainMod, P, pseudo, # dwindle
          # bind = $mainMod, J, togglesplit, # dwindle

          ## Passthrough SUPER KEY to Virtual Machine
          bind = $mainMod, P, submap, passthru
          submap = passthru
          bind = SUPER, Escape, submap, reset
          submap = reset

          # Fn keys
          bind = , XF86Launch3, exec, $browser_alternate
          bind = , XF86MonBrightnessUp, exec, brightnessctl -q s +10%
          bind = , XF86MonBrightnessDown, exec, brightnessctl -q s 10%-
          bind = , XF86AudioRaiseVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ +5%
          bind = , XF86AudioLowerVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ -5%
          bind = , XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
          bind = , XF86AudioMicMute, exec, pactl set-source-mute @DEFAULT_SOURCE@ toggle
          bind = , XF86AudioPlay, exec, playerctl play-pause
          bind = , XF86AudioPause, exec, playerctl pause
          bind = , XF86AudioNext, exec, playerctl next
          bind = , XF86AudioPrev, exec, playerctl previous
          bind = ALT, V, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy # Clipboard Manager

          # Move focus with mainMod + arrow keys
          bind = $mainMod, h, movefocus, l
          bind = $mainMod, l, movefocus, r
          bind = $mainMod, j, movefocus, u
          bind = $mainMod, k, movefocus, d

          # Switch workspaces with mainMod + [0-9]
          bind = $mainMod, 1, workspace, 1
          bind = $mainMod, 2, workspace, 2
          bind = $mainMod, 3, workspace, 3
          bind = $mainMod, 4, workspace, 4
          bind = $mainMod, 5, workspace, 5
          bind = $mainMod, 6, workspace, 6
          bind = $mainMod, 7, workspace, 7
          bind = $mainMod, 8, workspace, 8
          bind = $mainMod, 9, workspace, 9
          bind = $mainMod, 0, workspace, 10

          # Move active window to a workspace with mainMod + SHIFT + [0-9]
          bind = $mainMod SHIFT, 1, movetoworkspace, 1
          bind = $mainMod SHIFT, 2, movetoworkspace, 2
          bind = $mainMod SHIFT, 3, movetoworkspace, 3
          bind = $mainMod SHIFT, 4, movetoworkspace, 4
          bind = $mainMod SHIFT, 5, movetoworkspace, 5
          bind = $mainMod SHIFT, 6, movetoworkspace, 6
          bind = $mainMod SHIFT, 7, movetoworkspace, 7
          bind = $mainMod SHIFT, 8, movetoworkspace, 8
          bind = $mainMod SHIFT, 9, movetoworkspace, 9
          bind = $mainMod SHIFT, 0, movetoworkspace, 10

          # Example special workspace (scratchpad)
          bind = $mainMod, S, togglespecialworkspace, magic
          bind = $mainMod SHIFT, S, movetoworkspace, special:magic

          # Scroll through existing workspaces with mainMod + scroll
          bind = $mainMod, mouse_down, workspace, e+1
          bind = $mainMod, mouse_up, workspace, e-1

          # Move/resize windows with mainMod + LMB/RMB and dragging
          bindm = $mainMod, mouse:272, movewindow
          bindm = $mainMod, mouse:273, resizewindow
          bindm = $mainMod ALT, mouse:272, resizewindow
        ''
        + ''
          monitor=,preferred,auto,1

          exec-once = nm-applet &
          exec-once = blueman-applet &
          exec-once = localsend_app --hidden
          exec-once = wl-paste --type text --watch cliphist store # clipboard store text data
          exec-once = wl-paste --type image --watch cliphist store # clipboard store image data
        '';
    };
  };
})
args
