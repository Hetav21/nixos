{
  config,
  lib,
  pkgs,
  inputs,
  options,
  ...
}: let
in {
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
        # Define environment variables here
        Environment = {
          LIBVA_DRIVER_NAME = "iHD";
          ELECTRON_OZONE_PLATFORM_HINT = "wayland";
        };
      };
    };
    packages = [
      "org.texstudio.TeXstudio"
      "com.todoist.Todoist"
      "com.spotify.Client"
      "org.gnome.Loupe"
      "com.microsoft.Edge"
      "com.github.IsmaelMartinez.teams_for_linux"
      "org.libreoffice.LibreOffice"
      "com.github.tchx84.Flatseal"
      "com.stremio.Stremio"
      "com.calibre_ebook.calibre"
    ];
  };
}
