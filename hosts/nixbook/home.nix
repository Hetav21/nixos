{pkgs, ...}: {
  imports = [
    ../_common/home-base.nix
  ];

  # Enable all terminal modules
  home.terminal.shell.enable = true;
  home.terminal.tmux.enable = true;
  home.terminal.alacritty.enable = true;
  home.terminal.ghostty.enable = true;

  # Enable all desktop modules
  home.desktop.hyprland.enable = true;
  home.desktop.hypridle.enable = true;
  home.desktop.hyprlock.enable = true;
  home.desktop.hyprshot.enable = true;
  home.desktop.clipboard.enable = true;
  home.desktop.launcher.enable = true;
  home.desktop.notification.enable = true;
  home.desktop.rofi.enable = true;
  home.desktop.wallpaper.enable = true;
  home.desktop.waybar.enable = true;
  home.desktop.wlogout.enable = true;
  home.desktop.programming.enable = true;

  # Enable browser
  home.browser.zen.enable = true;

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
