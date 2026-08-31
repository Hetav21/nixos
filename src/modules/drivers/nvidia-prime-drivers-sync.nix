{
  extraLib,
  hardware,
  ...
} @ args:
extraLib.modules.mkModule args {
  name = "drivers.nvidia.prime.sync";
  hasGui = false;
  cliConfig = {
    # --- Nvidia PRIME Sync Configuration ---
    hardware.nvidia.prime = {
      sync.enable = hardware.nvidia.prime.sync.enable;
      inherit (hardware.nvidia.prime) intelBusId nvidiaBusId;
    };
  };
}

