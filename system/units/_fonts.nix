{
  config,
  lib,
  pkgs,
  inputs,
  options,
  ...
}: let
in {
  fonts.packages = with pkgs; [
    roboto
    montserrat
    liberation_ttf
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    fira-code
    fira-sans
    fira-code-symbols
    dina-font
    proggyfonts
    mplus-outline-fonts.githubRelease
    font-awesome
    material-icons
    nerd-fonts.ubuntu-sans
  ];

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
      package = pkgs.nerd-fonts.ubuntu-sans;
      name = "Ubuntu";
    };
    sizes = {
      applications = 12;
      terminal = 15;
      desktop = 11;
      popups = 12;
    };
  };
}
