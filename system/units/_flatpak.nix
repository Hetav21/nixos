{pkgs, ...}: {
  # Nix-Flatpak
  services.flatpak = {
    enable = true;
    package = pkgs.latest.flatpak;
    uninstallUnmanaged = true;
    update.auto = {
      enable = true;
      onCalendar = "daily";
    };
    overrides = {
      global = {
        Environment = {
          LIBVA_DRIVER_NAME = "nvidia";
          ELECTRON_OZONE_PLATFORM_HINT = "wayland";
        };
      };
    };
    packages = [
      "org.gnome.Loupe" # Image Viewer
      "org.kde.kdenlive" # Video Editor
      "com.github.PintaProject.Pinta" # Image Editor
      "io.gitlab.theevilskeleton.Upscaler" # Image Upscaler
      "org.libreoffice.LibreOffice" # Office Suite
      "org.onlyoffice.desktopeditors" # Office Suite
      "io.github.flattool.Warehouse" # Flatpak Manager
      "com.github.tchx84.Flatseal" # Flatpak Permissions Manager
      "org.texstudio.TeXstudio" # LaTeX Editor
      "com.sublimetext.three" # Sublime Text Editor
    ];
  };
}
