{...}: {
  # --- Driver Submodules ---
  imports = [
    ./amd-drivers.nix
    ./asus.nix
    ./intel-drivers.nix
    ./nvidia-drivers.nix
    ./nvidia-prime-drivers-offload.nix
    ./nvidia-prime-drivers-sync.nix
  ];
}
