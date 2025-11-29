commonSettings:
commonSettings
// {
  hostname = "nixwslbook";
  # Add wallpaper for stylix TUI/CLI theming (color scheme generation)
  wallpaper = "China.jpeg";
  # Override update strings to exclude desktop-only inputs (lanzaboote, nix-flatpak, zen-browser, vicinae)
  update-standard = "stylix home-manager sops-nix";
  update-latest = "nixpkgs-unstable nixpkgs-master chaotic nur stylix home-manager sops-nix";
}
