{pkgs, ...}: {
  environment.systemPackages = with pkgs; [xfce.thunar];

  programs = {
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [thunar-archive-plugin thunar-volman];
    };
  };
}
