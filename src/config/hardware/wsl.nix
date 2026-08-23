{
  # --- OEM / Vendor Hardware ---
  asus.enable = false;

  # --- CPU / Integrated GPU ---
  intel.enable = false;
  amdgpu.enable = false;

  # --- Dedicated GPU ---
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
