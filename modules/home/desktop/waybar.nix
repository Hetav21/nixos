{
  extraLib,
  lib,
  config,
  ...
} @ args:
(extraLib.modules.mkModule {
  name = "home.desktop.waybar";
  hasCli = false;
  hasGui = true;
  guiConfig = _: {
    stylix.targets.waybar.enable = false;
    programs.waybar = {
      enable = true;
      systemd = {
        enable = true;
        target = "hyprland-session.target";
      };
      settings = [
        {
          layer = "top";
          position = "top";
          height = 40;
          gtk-layer-shell = true;
          exclusive = true;
          passthrough = false;

          modules-left = [
            "custom/left"
            "custom/rofi"
            "backlight"
            "pulseaudio"
            "pulseaudio#microphone"
            "battery"
            "custom/right"
          ];
          modules-center = ["custom/left" "hyprland/workspaces" "custom/right"];
          modules-right = ["custom/left" "tray" "clock" "custom/right"];

          "network" = {
            tooltip = true;
            format-wifi = "<span foreground='#FF8B49'> {bandwidthDownBytes}</span> <span foreground='#FF6962'> {bandwidthUpBytes}</span>";
            format-ethernet = "<span foreground='#FF8B49'> {bandwidthDownBytes}</span> <span foreground='#FF6962'> {bandwidthUpBytes}</span>";
            tooltip-format = ''
              Network: <big><b>{essid}</b></big>
              Signal strength: <b>{signaldBm}dBm ({signalStrength}%)</b>
              Frequency: <b>{frequency}MHz</b>
              Interface: <b>{ifname}</b>
              IP: <b>{ipaddr}/{cidr}</b>
              Gateway: <b>{gwaddr}</b>
              Netmask: <b>{netmask}</b>'';
            format-linked = "󰈀 {ifname} (No IP)";
            format-disconnected = " 󰖪 ";
            tooltip-format-disconnected = "Disconnected";
            interval = 2;
            on-click-right = "~/.config/waybar/network.py";
          };

          "temperature" = {format = "{temperatureC}°C ";};

          "custom/rofi" = {
            format = "  {}";
            on-click = "rofi -show drun";
          };

          "hyprland/workspaces" = {
            disable-scroll = true;
            all-outputs = true;
            on-click = "activate";
          };

          "battery" = {
            states = {
              good = 95;
              warning = 30;
              critical = 20;
            };
            format = "{icon} {capacity}%";
            format-charging = " {capacity}%";
            format-plugged = " {capacity}%";
            format-alt = "{time} {icon}";
            format-icons = ["󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
          };

          "pulseaudio" = {
            format = "{icon} {volume}";
            format-muted = "󰖁";
            on-click = "pavucontrol -t 3";
            tooltip-format = "{icon} {desc} // {volume}%";
            scroll-step = 5;
            format-icons = {
              headphone = "";
              "hands-free" = "";
              headset = "";
              phone = "";
              portable = "";
              car = "";
              default = ["" "" ""];
            };
          };

          "pulseaudio#microphone" = {
            "format" = "{format_source}";
            "format-source" = "";
            "format-source-muted" = "";
            "on-click" = "pavucontrol -t 4";
          };

          "tray" = {
            icon-size = 20;
            spacing = 9;
          };

          "clock" = {
            format = " {:%H:%M}";
            on-click = "~/.config/eww/scripts/toggle_control_center.sh";
          };

          "backlight" = {
            device = "intel_backlight";
            on-scroll-up = "light -A 7";
            on-scroll-down = "light -U 7";
            format = "{icon} {percent}%";
            format-icons = ["󰃞" "󰃟" "󰃠" "󱩎" "󱩏" "󱩐" "󱩑" "󱩒" "󱩓" "󰛨"];
          };

          "custom/left" = {
            format = " ";
            interval = "once";
            tooltip = false;
          };

          "custom/right" = {
            format = " ";
            interval = "once";
            tooltip = false;
          };
        }
      ];
      style = ''
        * {
          border: none;
          border-radius: 0px;
          font-family: "JetBrainsMono Nerd Font";
          font-weight: bold;
          font-size: 15px;
          min-height: 13px;
        }

        window#waybar {
          background-color: rgba(0, 0, 0, 0);
        }

        #battery,
        #temperature,
        #clock,
        #workspaces,
        #custom-rofi,
        #tray,
        #pulseaudio,
        #pulseaudio#microphone,
        #backlight,
        #network,
        #custom-right,
        #custom-left {
          color: #e0def4; /* Rose Pine Moon - Text */
          background: #232136; /* Rose Pine Moon - Base */
          margin: 4px 0px 4px 0px;
          opacity: 1;
          border: 0px solid #181825;
        }

        tooltip {
          background: #232136; /* Rose Pine Moon - Base */
          color: #e0def4; /* Rose Pine Moon - Text */
          border-radius: 22px;
          border-width: 2px;
          border-style: solid;
          border-color: #393552; /* Rose Pine Moon - Overlay */
        }

        #workspaces button {
          box-shadow: none;
          text-shadow: none;
          padding: 0px;
          border-radius: 9px;
          margin-top: 3px;
          margin-bottom: 3px;
          padding-left: 3px;
          padding-right: 3px;
          color: #e0def4; /* Rose Pine Moon - Text */
          animation: gradient_f 20s ease-in infinite;
          transition: all 0.5s cubic-bezier(0.55, -0.68, 0.48, 1.682);
        }

        #workspaces button.active {
          background: #393552; /* Rose Pine Moon - Overlay */
          color: #c4a7e7; /* Rose Pine Moon - Iris */
          margin-left: 3px;
          padding-left: 12px;
          padding-right: 12px;
          margin-right: 3px;
          animation: gradient_f 20s ease-in infinite;
          transition: all 0.3s cubic-bezier(0.55, -0.68, 0.48, 1.682);
        }

        #workspaces button:hover {
          background: #2a273f; /* Rose Pine Moon - Surface */
          border: none;
        }

        #workspaces {
          padding: 0px;
          padding-left: 5px;
          padding-right: 5px;
        }

        #custom-rofi {
          color: #ea9a97; /* Rose Pine Moon - Rose */
          padding-left: 0px;
          padding-right: 10px;
        }

        #temperature {
          color: #9ccfd8; /* Rose Pine Moon - Foam */
          padding-left: 0px;
          padding-right: 19px;
        }

        #temperature.critical {
          color: #eb6f92; /* Rose Pine Moon - Love */
          padding-left: 0px;
          padding-right: 19px;
        }

        #backlight {
          color: #f6c177; /* Rose Pine Moon - Gold */
          padding-left: 0px;
          padding-right: 19px;
        }

        #pulseaudio {
          color: #c4a7e7; /* Rose Pine Moon - Iris */
          padding-left: 0px;
          padding-right: 19px;
        }

        #battery {
          color: #3e8fb0; /* Rose Pine Moon - Pine */
          padding-left: 0px;
          padding-right: 0px;
        }

        #tray {
          padding-left: 0px;
          padding-right: 19px;
        }

        #network {
          padding-left: 0px;
          padding-right: 19px;
        }

        #clock {
          color: #ea9a97; /* Rose Pine Moon - Rose */
          padding-left: 0px;
          padding-right: 0px;
        }

        #custom-right {
          margin-right: 9px;
          padding-right: 3px;
          border-radius: 0px 22px 22px 0px;
        }

        #custom-left {
          margin-left: 9px;
          padding-left: 3px;
          border-radius: 22px 0px 0px 22px;
        }
      '';
    };
  };
})
args
