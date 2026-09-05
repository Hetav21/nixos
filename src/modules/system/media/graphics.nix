{
  extraLib,
  pkgs,
  ...
} @ args:
extraLib.modules.mkModule args {
  name = "system.media.graphics";
  hasCli = false;
  hasGui = true;
  guiConfig = {
    # --- Graphics & Video Flatpaks ---
    services.flatpak.packages = [
      "org.gnome.Loupe"
      # "com.github.PintaProject.Pinta" # Lightweight drawing and image editing program
      # "org.kde.kdenlive" # Non-linear video editor
    ];

    # --- Upscayl Image Upscaler ---
    environment.systemPackages = [
      # pkgs.upscayl # Upscayl AI image upscaler
    ];
  };
}
