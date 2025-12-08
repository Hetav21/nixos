# nixwslbook host-specific settings
# These are merged with common.nix using hostLib.mkHostSettings
{
  hostname = "nixwslbook";

  # Add wallpaper for stylix TUI/CLI theming (color scheme generation)
  wallpaper = "China.jpeg";

  # Build configuration for WSL (shared resources with Windows)
  nix = {
    maxJobs = 2;
    cores = 4;
  };

  # Override update strings to exclude desktop-only inputs
  # (lanzaboote, nix-flatpak, zen-browser, vicinae are not used in WSL)
  update-standard = "stylix home-manager sops-nix";
  update-latest = "nixpkgs-unstable nixpkgs-master chaotic nur";
}
