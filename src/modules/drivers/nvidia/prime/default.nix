# NVIDIA PRIME Configuration Module
#
# Declares shared PRIME bus IDs and aggregates PRIME offload and sync mode submodules.
{lib, ...}: {
  # --- PRIME Mode Submodules ---
  imports = [
    ./offload.nix
    ./sync.nix
  ];

  # --- Shared PRIME Declarative Options ---
  options.drivers.nvidia.prime = {
    intelBusId = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "PCI Bus ID of the Intel/AMD integrated GPU (e.g. PCI:0:2:0).";
    };

    nvidiaBusId = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "PCI Bus ID of the discrete NVIDIA GPU (e.g. PCI:1:0:0).";
    };
  };
}
