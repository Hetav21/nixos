{...}: {
  # Nix-Flatpak
  services.flatpak = {
    enable = true;
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
      "com.microsoft.Edge"
      "net.blix.BlueMail"
      "org.texstudio.TeXstudio"
      "io.github.JakubMelka.Pdf4qt"
      "com.github.jeromerobert.pdfarranger"
      "com.spotify.Client"
      "org.gnome.Loupe"
      "com.github.IsmaelMartinez.teams_for_linux"
      "org.libreoffice.LibreOffice"
      "com.github.tchx84.Flatseal"
      "com.stremio.Stremio"
      "com.calibre_ebook.calibre"
      "org.gnome.Papers"
    ];
  };
}
