{pkgs, ...}: {
  programs.ghostty = {
    enable = true;
    package = pkgs.unstable.ghostty;

    settings = {
      confirm-close-surface = false;
      copy-on-select = true;
      minimum-contrast = 1.1;
      window-decoration = false;
      window-padding-x = 16;
      window-padding-y = 16;
    };
  };
}
