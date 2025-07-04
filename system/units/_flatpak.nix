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
      "com.sublimetext.three"
      "com.microsoft.Edge"
      "net.blix.BlueMail"
      "org.texstudio.TeXstudio"
      "io.github.JakubMelka.Pdf4qt"
      "com.github.jeromerobert.pdfarranger"
      "com.spotify.Client"
      "com.github.IsmaelMartinez.teams_for_linux"
      "org.libreoffice.LibreOffice"
      "com.github.tchx84.Flatseal"
      "com.stremio.Stremio"
      "org.gnome.Papers"
      "io.github.flattool.Warehouse"
      "de.schmidhuberj.tubefeeder"
      "me.iepure.devtoolbox"
      "io.github.alainm23.planify"
    ];
  };
}
