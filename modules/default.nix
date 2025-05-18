{...}: let
in {
  imports = [
    ./drivers/amd-drivers.nix
    ./drivers/intel-drivers.nix
    ./drivers/nvidia-drivers.nix
    ./drivers/nvidia-prime-drivers-offload.nix
    ./drivers/nvidia-prime-drivers-sync.nix
    ./misc/disk-decryption.nix
    ./misc/mount-partition.nix
    ./misc/local-hardware-clock.nix
    ./misc/vm-guest-services.nix
  ];
}
