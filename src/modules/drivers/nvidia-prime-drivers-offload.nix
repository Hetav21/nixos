{
  extraLib,
  hardware,
  ...
} @ args:
extraLib.modules.mkModule args {
  name = "drivers.nvidia.prime.offload";
  hasGui = false;
  cliConfig = {
    # --- Nvidia PRIME Offload Configuration ---
    hardware.nvidia.prime = {
      offload = {
        enable = hardware.nvidia.prime.offload.enable;
        enableOffloadCmd = hardware.nvidia.prime.offload.enable;
      };
      inherit (hardware.nvidia.prime) intelBusId nvidiaBusId;
    };
  };
}

