{...}: {
  # --- Host Imports & Path Setup ---
  imports = [
    ../_common
    ../_common/wsl-base.nix
  ];

  local.homeConfig = ./home.nix;
}
