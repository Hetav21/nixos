{...}: {
  # --- Host Imports & Path Setup ---
  imports = [
    ../../core/wsl.nix
  ];

  local.homeConfig = ./home.nix;
}
