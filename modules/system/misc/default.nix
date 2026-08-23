{...}: {
  # --- Miscellaneous Modules ---
  imports = [
    ./disk-decryption.nix
    ./local-hardware-clock.nix
    ./mount-partition.nix
    ./vm-guest-services.nix
  ];
}
