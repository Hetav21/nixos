{pkgs, ...}: {
  fonts = {
    enableDefaultPackages = true;

    fontconfig = {
      hinting = {
        enable = true;
        style = "slight";
        autohint = false;
      };
      antialias = true;
      subpixel = {
        rgba = "rgb";
        lcdfilter = "default";
      };
    };

    packages = with pkgs; [nerd-fonts.jetbrains-mono dejavu_fonts fira-code-nerdfont];
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
