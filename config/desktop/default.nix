{...}: let
in {
  imports = [
    ./hypridle.nix
    ./hyprland.nix
    ./hyprlock.nix
    ./waybar.nix
  ];
}
