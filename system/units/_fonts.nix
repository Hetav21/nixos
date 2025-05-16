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
      fira-code
      nerd-fonts.jetbrains-mono
    ];
  };

  stylix.fonts = {
    monospace = {
      package = pkgs.nerd-fonts.ubuntu-sans;
      name = "Ubuntu Mono";
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
