{...}: let
in {
  imports = [
    ./drivers/amd-drivers.nix
    ./drivers/intel-drivers.nix
    ./drivers/nvidia-drivers.nix
    ./drivers/nvidia-prime-drivers.nix
    ./misc/disk-decryption.nix
    ./misc/local-hardware-clock.nix
    ./misc/vm-guest-services.nix
  ];
}
