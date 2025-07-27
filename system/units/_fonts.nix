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

    packages = with pkgs; [nerd-fonts.jetbrains-mono nerd-fonts.fira-code dejavu_fonts];
  };

  stylix.fonts = {
    monospace = {
      package = pkgs.nerd-fonts.jetbrains-mono;
      name = "JetBrainsMono Nerd Font Mono";
    };
    sansSerif = {
      package = pkgs.nerd-fonts.ubuntu-sans;
      name = "UbuntuSans Nerd Font";
    };
    serif = {
      package = pkgs.nerd-fonts.noto;
      name = "NotoSerif Nerd Font";
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
