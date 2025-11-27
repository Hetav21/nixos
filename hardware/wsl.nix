{
  # Minimal hardware configuration for WSL (no physical hardware)
  asus.enable = false;
  intel.enable = false;
  amdgpu.enable = false;
  nvidia = {
    enable = false;
    package = "stable";
    prime = {
      sync.enable = false;
      offload.enable = false;
      intelBusId = "";
      nvidiaBusId = "";
    };
  };
}

