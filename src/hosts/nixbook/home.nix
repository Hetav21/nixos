{
  pkgs,
  lib,
  extraLib,
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
      ".config/mpv".source = extraLib.paths.dotfile ".config/mpv";
      ".config/wlogout/icons".source = extraLib.paths.dotfile ".config/wlogout/icons";
      ".local/bin/cliphist-rofi-img".source = extraLib.paths.dotfile ".local/bin/cliphist-rofi-img";
      ".config/autostart/mega-sync.desktop".source = extraLib.paths.dotfile ".config/autostart/mega-sync.desktop";
    };

    packages = [
      pkgs.custom.rofi-launcher
    ];
  };
}
