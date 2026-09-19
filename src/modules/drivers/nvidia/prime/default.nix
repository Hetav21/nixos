# NVIDIA PRIME Configuration Module
#
# Declares shared PRIME bus IDs, validates mode exclusivity,
# and aggregates PRIME offload and sync mode submodules.
{
  lib,
  config,
  ...
}: {
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

  # --- Shared PRIME Hardware Configuration ---
  config = lib.mkIf (config.drivers.nvidia.prime.sync.enable || config.drivers.nvidia.prime.offload.enable) {
    # --- Validation Assertions ---
    assertions = [
      {
        assertion = config.drivers.nvidia.enable;
        message = "NVIDIA PRIME modes require drivers.nvidia.enable = true.";
      }
      {
        assertion = !(config.drivers.nvidia.prime.sync.enable && config.drivers.nvidia.prime.offload.enable);
        message = "NVIDIA PRIME 'sync' and 'offload' modes are mutually exclusive. Only one can be enabled at a time.";
      }
    ];

    # --- Hardware PRIME Bus IDs ---
    hardware.nvidia.prime = {
      inherit (config.drivers.nvidia.prime) intelBusId nvidiaBusId;
    };
  };
}
