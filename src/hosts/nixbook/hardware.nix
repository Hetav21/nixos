# Host Hardware & Driver Configuration for nixbook
#
# Configures host-specific hardware drivers, vendor integration,
# and discrete GPU / PRIME configuration for the ASUS ROG Zephyrus G16.
{...}: {
  # --- OEM / Vendor Hardware ---
  drivers.asus = {
    enable = true;
    enableGui = true;
  };

  # --- CPU / Integrated GPU ---
  drivers.intel.enable = true;
  drivers.amdgpu.enable = false;

  # --- Dedicated GPU (NVIDIA Hybrid) ---
  drivers.nvidia = {
    enable = true;
    package = "stable";
    prime = {
      sync.enable = false;
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
}
