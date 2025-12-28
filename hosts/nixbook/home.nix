{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ../_common/home-base.nix
  ];

  # Host-specific stateVersion
  home.stateVersion = lib.mkForce "25.11";

  # Enable full desktop profile (includes GTK/Qt configuration)
  profiles.home.desktop-full.enable = true;

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
