# Hardware Vendor & Graphics Drivers Aggregator
#
# Aggregates hardware and vendor-specific drivers (AMD, ASUS, Intel, NVIDIA).
# Drivers are selectively enabled via host hardware profiles.
{...}: {
  # --- Driver Submodules ---
  imports = [
    ./amdgpu.nix
    ./asus.nix
    ./intel.nix
    ./nvidia
  ];
}
