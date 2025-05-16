{
  config,
  lib,
  pkgs,
  inputs,
  options,
  ...
}: let
in {
  fonts = {
    enableDefaultPackages = true;

    packages = with pkgs; [
      noto-fonts
      fira-code
    ];
  };

  stylix.fonts = {
    monospace = {
      package = pkgs.nerd-fonts.jetbrains-mono;
      name = "JetBrainsMono Nerd Font Mono";
    };
    sansSerif = {
      package = pkgs.nerd-fonts.ubuntu-sans;
      name = "Ubuntu";
    };
    serif = {
      package = pkgs.noto-fonts;
      name = "Noto Serif";
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
}
