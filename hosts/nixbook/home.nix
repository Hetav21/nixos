{pkgs, ...}: {
  imports = [
    ../_common/home-base.nix
  ];

  # Enable categorized modules with both CLI and GUI
  home.development = { enable = true; enableGui = true; };
  home.shell = { enable = true; enableGui = true; };
  home.system.enable = true;

  # Enable desktop modules (GUI only)
  home.desktop.hyprland.enableGui = true;
  home.desktop.hypridle.enableGui = true;
  home.desktop.hyprlock.enableGui = true;
  home.desktop.hyprshot.enableGui = true;
  home.desktop.clipboard.enableGui = true;
  home.desktop.launcher.enableGui = true;
  home.desktop.notification.enableGui = true;
  home.desktop.rofi.enableGui = false;
  home.desktop.wallpaper.enableGui = true;
  home.desktop.waybar.enableGui = true;
  home.desktop.wlogout.enableGui = true;

  # Enable browser
  home.browser.zen.enableGui = true;

  # GTK theming configuration
  gtk = {
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.unstable.papirus-icon-theme;
    };
    gtk3.extraConfig = {gtk-application-prefer-dark-theme = 1;};
    gtk4.extraConfig = {gtk-application-prefer-dark-theme = 1;};
  };

  # Qt configuration
  qt.enable = true;

  # Desktop-specific dotfiles and packages (host-specific overrides)
  home = {
    file = {
      ".config/mpv".source = ../../dotfiles/.config/mpv;
      ".config/wlogout/icons".source = ../../dotfiles/.config/wlogout/icons;
      ".local/bin/cliphist-rofi-img".source =
        ../../dotfiles/.local/bin/cliphist-rofi-img;
      ".config/autostart/mega-sync.desktop".source = ../../dotfiles/.config/autostart/mega-sync.desktop;
    };

    packages = [
      (pkgs.callPackage ../../scripts/desktop/rofi-launcher.nix {})
    ];
  };
}
