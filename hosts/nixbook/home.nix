{
  pkgs,
  config,
  ...
}: {
  imports = [
    ../_common/home-base.nix
  ];

  # Enable full desktop profile (includes GTK/Qt configuration)
  profiles.home.desktop-full.enable = true;

  # Host-specific GTK icon theme override
  gtk.iconTheme = {
    name = let
      suffix =
        if config.stylix.polarity == "dark"
        then "Dark"
        else "Light";
    in "Papirus-${suffix}";

    package = pkgs.unstable.papirus-icon-theme;
  };

  # Host-specific dotfiles and packages
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
