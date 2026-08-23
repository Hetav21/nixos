{
  # --- OEM / Vendor Hardware ---
  asus.enable = true;

  # --- CPU / Integrated GPU ---
  intel.enable = true;
  amdgpu.enable = false;

  # --- Dedicated GPU (NVIDIA Hybrid) ---
  nvidia = {
    enable = true;
    package = "stable";
    prime = {
      sync.enable = false;
      offload.enable = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
}
