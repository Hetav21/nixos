{
  extraLib,
  lib,
  pkgs,
  pkgs-unstable,
  ...
} @ args:
(extraLib.modules.mkModule {
  name = "home.desktop.notification";
  hasCli = false;
  hasGui = true;
  guiConfig = _: let
    hypr_border = 5; # adjust as per hyprland config
  in {
    home.packages = with pkgs; [libnotify];

    services.dunst = {
      enable = true;
      package = pkgs.dunst;

      iconTheme = {
        package = pkgs-unstable.tela-circle-icon-theme;
        name = "Tela-circle-dark";
        size = "16";
      };

      settings = {
        global = {
          monitor = 0;
          follow = "mouse";
          width = 300;
          height = "(0, 300)";
          origin = "top-right";
          offset = "(20, 20)";
          scale = 0;
          notification_limit = 20;
          progress_bar = true;
          progress_bar_height = 10;
          progress_bar_frame_width = 0;
          progress_bar_min_width = 125;
          progress_bar_max_width = 250;
          progress_bar_corner_radius = 4;
          icon_corner_radius = "${toString hypr_border}";
          indicate_hidden = true;
          transparency = 10;
          separator_height = 2;
          padding = 8;
          horizontal_padding = 8;
          text_icon_padding = 10;
          frame_width = 5;
          gap_size = 5;
          sort = true;
          line_height = 3;
          markup = "full";
          format = "%s\\n%b";
          alignment = "left";
          vertical_alignment = "center";
          show_age_threshold = 60;
          ellipsize = "middle";
          ignore_newline = false;
          stack_duplicates = true;
          hide_duplicate_count = false;
          show_indicators = true;
          icon_theme = "Tela-circle-dracula";
          icon_position = "left";
          min_icon_size = 32;
          max_icon_size = 128;
          sticky_history = true;
          history_length = 20;
          dmenu = "${lib.getExe pkgs.rofi} -dmenu -p dunst:";
          browser = "${lib.getExe' pkgs.xdg-utils "xdg-open"}";
          always_run_script = true;
          title = "Dunst";
          class = "Dunst";
          corner_radius = "${toString hypr_border}";
          ignore_dbusclose = false;
          layer = "top";
          force_xwayland = false;
          force_xinerama = false;
          mouse_left_click = ["context"];
          mouse_middle_click = ["do_action"];
          mouse_right_click = ["close_all"];
        };

        experimental = {per_monitor_dpi = false;};

        "Type-1" = {
          appname = "t1";
          format = "<b>%s</b>";
        };

        "Type-2" = {
          appname = "t2";
          format = ''<span size="250%%">%s</span> \n%b'';
        };

        urgency_low = {
          background = lib.mkForce "#3A4A6B80";
          foreground = lib.mkForce "#CCDDFFE6";
          frame_color = lib.mkForce "#3A4A6B03";
          timeout = 5;
        };

        urgency_normal = {
          background = lib.mkForce "#3A4A6B80";
          foreground = lib.mkForce "#CCDDFFE6";
          frame_color = lib.mkForce "#3A4A6B03";
          timeout = 5;
        };

        urgency_critical = {
          background = lib.mkForce "#3A4A6B80";
          foreground = lib.mkForce "#CCDDFFE6";
          frame_color = lib.mkForce "#3A4A6B03";
          timeout = 0;
        };
      };
    };
  };
})
args
