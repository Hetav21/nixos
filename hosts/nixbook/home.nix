{
  pkgs,
  lib,
  ...
}: {
  # --- Imports ---
  imports = [
    ../_common/home-base.nix
  ];

  # --- Profile & State Version ---
  profiles.home.desktop.enable = true;
  home.stateVersion = lib.mkForce "25.11";

  # --- Host-Specific Dotfiles & Packages ---
  home = {
    file = {
      ".config/mpv".source = ../../dotfiles/.config/mpv;
      ".config/wlogout/icons".source = ../../dotfiles/.config/wlogout/icons;
      ".local/bin/cliphist-rofi-img".source = ../../dotfiles/.local/bin/cliphist-rofi-img;
      ".config/autostart/mega-sync.desktop".source = ../../dotfiles/.config/autostart/mega-sync.desktop;
    };

    packages = [
      (pkgs.callPackage ../../scripts/desktop/rofi-launcher.nix {})
    ];
  };
}
