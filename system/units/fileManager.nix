{pkgs, ...}: let
in {
  environment.systemPackages = with pkgs; [
    yazi
    xfce.thunar
  ];

  programs = {
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
      ];
    };
  };
}
