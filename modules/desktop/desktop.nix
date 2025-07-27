{
  pkgs,
  settings,
  ...
}: {
  environment = {
    systemPackages = with pkgs; [
      # Wayland specific
      swww
      waypaper
      # grim swappy slurp
      hyprshot
    ];

    sessionVariables = {
      EDITOR = settings.editor;
      VISUAL = settings.visual;
      TERMINAL = settings.terminal;
      BROWSER = settings.browser;
      SIGNAL_PASSWORD_STORE = "gnome-libsecret";

      NIXOS_OZONE_WL = "1";
      GDK_BACKEND = "wayland,x11";
      QT_QPA_PLATFORM = "wayland;xcb";
      JAVA_AWT_WM_NONREPARENTING = "1";
      WLR_NO_HARDWARE_CURSORS = "1";
      MOZ_ENABLE_WAYLAND = "1";
      ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    };
  };

  systemd.user.services = {
    mute-on-boot = {
      enable = true;
      description = "Mutes microphone on boot";
      wantedBy = ["default.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "/run/current-system/sw/bin/pactl set-source-mute @DEFAULT_SOURCE@ 1";
        Restart = "on-failure";
        RestartSec = "10s";
      };
    };
  };

  programs = {
    hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
    };
  };

  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  fonts = {
    enableDefaultPackages = true;

    fontconfig = {
      hinting = {
        enable = true;
        style = "slight";
        autohint = false;
      };
      antialias = true;
      subpixel = {
        rgba = "rgb";
        lcdfilter = "default";
      };
    };

    packages = with pkgs; [nerd-fonts.jetbrains-mono nerd-fonts.fira-code dejavu_fonts];
  };

  stylix = {
    enable = true;
    base16Scheme = {
      base00 = "191724";
      base01 = "1f1d2e";
      base02 = "26233a";
      base03 = "6e6a86";
      base04 = "908caa";
      base05 = "e0def4";
      base06 = "e0def4";
      base07 = "524f67";
      base08 = "eb6f92";
      base09 = "f6c177";
      base0A = "ebbcba";
      base0B = "31748f";
      base0C = "9ccfd8";
      base0D = "c4a7e7";
      base0E = "f6c177";
      base0F = "524f67";
    };
    image = ../../wallpapers/${settings.wallpaper};
    polarity = "dark";
    opacity.terminal = 0.8;
    cursor.package = pkgs.bibata-cursors;
    cursor.name = "Bibata-Modern-Ice";
    cursor.size = 24;

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font Mono";
      };
      sansSerif = {
        package = pkgs.nerd-fonts.ubuntu-sans;
        name = "UbuntuSans Nerd Font";
      };
      serif = {
        package = pkgs.nerd-fonts.noto;
        name = "NotoSerif Nerd Font";
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
      sizes = {
        applications = 12;
        terminal = 15;
        desktop = 11;
        popups = 12;
      };
    };
  };
}
