{
  asus.enable = true;
  intel.enable = true;
  amdgpu.enable = false;
  nvidia = {
    enable = true;
    package = "stable"; # stable / beta
    prime = {
      sync.enable = false;
      offload.enable = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
}
