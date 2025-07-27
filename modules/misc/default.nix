{...}: {
  imports = [
    ./disk-decryption.nix
    ./mount-partition.nix
    ./local-hardware-clock.nix
    ./vm-guest-services.nix
  ];
}
