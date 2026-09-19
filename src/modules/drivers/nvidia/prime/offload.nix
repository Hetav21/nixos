# NVIDIA PRIME Render Offload Module
#
# Configures NVIDIA PRIME render offload for hybrid graphics laptops,
# routing rendering through the discrete GPU on demand via prime-run.
{
  extraLib,
  config,
  lib,
  ...
} @ args:
extraLib.modules.mkModule args {
  name = "drivers.nvidia.prime.offload";
  hasGui = false;

  # --- Declarative Options ---
  extraOptions = {
    drivers.nvidia.prime.offload = {
      enable = lib.mkEnableOption "NVIDIA PRIME render offload mode (render on dGPU on-demand)";
      enableOffloadCmd = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to enable the prime-run / nvidia-offload command wrapper.";
      };
    };
  };

  # --- PRIME Offload Configuration ---
  cliConfig = {
    hardware.nvidia.prime = {
      offload = {
        enable = config.drivers.nvidia.prime.offload.enable;
        enableOffloadCmd = config.drivers.nvidia.prime.offload.enableOffloadCmd;
      };
      inherit (config.drivers.nvidia.prime) intelBusId nvidiaBusId;
    };
  };
}
