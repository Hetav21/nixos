{hardware, ...}: {
  hardware.nvidia = {
    prime = {
      sync.enable = hardware.nvidia.prime.sync.enable;
      intelBusId = hardware.nvidia.prime.intelBusId;
      nvidiaBusId = hardware.nvidia.prime.nvidiaBusId;
    };
  };
}
