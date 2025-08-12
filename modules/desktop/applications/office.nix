{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # File management and archives
    xfce.thunar
    file-roller

    # Audio and video
    pavucontrol
    obs-studio
    mpv
    yt-dlp

    # Image and graphics

    # Productivity and office
    unstable.obsidian
    texliveMinimal

    # Fun and customization

    # Networking

    # Education

    # Miscellaneous
  ];

  # Flatpak
  services.flatpak.packages = [
    "org.gnome.Loupe" # Image Viewer
    "org.kde.kdenlive" # Video Editor
    "com.github.PintaProject.Pinta" # Image Editor
    "io.gitlab.theevilskeleton.Upscaler" # Image Upscaler
    "org.libreoffice.LibreOffice" # Office Suite
    "org.onlyoffice.desktopeditors" # Office Suite
    "org.texstudio.TeXstudio" # LaTeX Editor
    "com.github.IsmaelMartinez.teams_for_linux" # Teams Client
  ];

  programs = {
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [thunar-archive-plugin thunar-volman];
    };
  };
}
