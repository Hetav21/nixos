{
  extraLib,
  pkgs,
  ...
} @ args:
extraLib.modules.mkModule args {
  name = "system.productivity.latex";
  hasCli = false;
  hasGui = true;
  guiConfig = {
    # --- Packages ---
    environment.systemPackages = [
      # pkgs.texliveMinimal # Minimal TeX Live LaTeX distribution
    ];

    # --- Flatpak Applications ---
    services.flatpak.packages = [
      # "org.texstudio.TeXstudio" # TeXstudio LaTeX editor and IDE
    ];
  };
}
