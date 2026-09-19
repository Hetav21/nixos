# Intel Graphics Acceleration Module
#
# Configures VA-API media drivers, hardware video processing runtimes,
# and 32-bit acceleration libraries for Intel integrated graphics.
{
  extraLib,
  pkgs,
  ...
} @ args:
extraLib.modules.mkModule args {
  name = "drivers.intel";
  hasGui = false;

  # --- Driver Configuration ---
  cliConfig = {
    # --- Hardware Video Acceleration ---
    hardware.graphics = {
      extraPackages = [
        pkgs.intel-media-driver
        pkgs.vpl-gpu-rt
        pkgs.libvdpau-va-gl
        pkgs.libva-vdpau-driver
      ];

      extraPackages32 = [
        pkgs.pkgsi686Linux.intel-media-driver
      ];
    };
  };
}
