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
  ];
}
