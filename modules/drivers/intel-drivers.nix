{
  extraLib,
  pkgs,
  ...
} @ args:
extraLib.modules.mkModule args {
  name = "drivers.intel";
  hasGui = false;
  cliConfig = {
    # --- Intel Graphics Acceleration ---
    hardware.graphics = {
      extraPackages = [
        pkgs.intel-media-driver
        pkgs.vpl-gpu-rt
        pkgs.libvdpau-va-gl
        pkgs.libva-vdpau-driver
      ];

      extraPackages32 = [pkgs.pkgsi686Linux.intel-media-driver];
    };
  };
}
