{hardware, ...}: {
  hardware.nvidia = {
    prime = {
      offload = {
        enable = hardware.nvidia.prime.offload.enable;
        enableOffloadCmd = hardware.nvidia.prime.offload.enable;
      };
      intelBusId = hardware.nvidia.prime.intelBusId;
      nvidiaBusId = hardware.nvidia.prime.nvidiaBusId;
    };
  };
}
