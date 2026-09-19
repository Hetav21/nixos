# NVIDIA PRIME Sync Mode Module
#
# Configures NVIDIA PRIME sync mode for hybrid graphics laptops,
# running all rendering continuously on the discrete GPU for maximum performance.
{
  extraLib,
  lib,
  config,
  ...
} @ args:
extraLib.modules.mkModule args {
  name = "drivers.nvidia.prime.sync";
  hasGui = false;

  # --- Declarative Module Options ---
  extraOptions = {
    drivers.nvidia.prime.sync = {
      enable = lib.mkEnableOption "NVIDIA PRIME sync mode (continuous dGPU rendering)";
    };
  };

  # --- PRIME Sync Configuration ---
  cliConfig = {
    hardware.nvidia.prime.sync.enable = config.drivers.nvidia.prime.sync.enable;
  };
}
