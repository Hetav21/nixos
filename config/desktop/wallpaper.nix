{pkgs, ...}: {
  home.packages = with pkgs; [
    waypaper
  ];

  services.swww = {
    enable = true;
    package = pkgs.swww;
  };
}
