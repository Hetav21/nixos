{
  lib,
  settings,
  ...
}: {
  programs.alacritty = {
    enable = true;
    settings = {
      bell = {
        animation = "EaseOutCirc";
        color = "0x464d6a";
        duration = 0;
      };

      colors = {draw_bold_text_with_bright_colors = false;};

      cursor = {
        blink_interval = 500;
        thickness = 0.15;
        unfocused_hollow = true;
      };

      cursor.style = {
        blinking = "On";
        shape = "Block";
      };

      font.bold = {
        family = "JetBrainsMono Nerd Font";
        style = "Bold";
      };

      font.bold_italic = {
        family = "JetBrainsMono Nerd Font";
        style = "Bold Italic";
      };

      font.italic = {
        family = "JetBrainsMono Nerd Font";
        style = "Italic";
      };

      font.normal = {
        family = lib.mkForce "JetBrainsMono Nerd Font";
        style = "Regular";
      };

      font.offset = {
        x = 0;
        y = 0;
      };

      hints.enabled = [
        {
          regex = "[^ ]+\\\\.rs:\\\\d+:\\\\d+";
          command = {
            program = settings.visual;
            args = ["--goto"];
          };
          mouse = {enabled = true;};
        }
      ];

      mouse = {hide_when_typing = false;};

      mouse.bindings = [
        {
          action = "PasteSelection";
          mouse = "Middle";
        }
        {
          action = "Copy";
          mouse = "Right";
        }
      ];

      scrolling = {
        history = 500;
        multiplier = 1;
      };

      window = {
        decorations = "full";
        decorations_theme_variant = "Dark";
        dynamic_title = true;
        # opacity = 0.7;
        startup_mode = "Windowed";
        title = "Alacritty";
        dynamic_padding = false;
      };

      window.class = {
        general = "Alacritty";
        instance = "Alacritty";
      };

      window.padding = {
        x = 5;
        y = 5;
      };

      general = {
        live_config_reload = true;
        working_directory = "None";
      };
    };
  };
}
