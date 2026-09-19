# AMD Radeon GPU & ROCm Acceleration Module
#
# Configures the amdgpu video driver and ROCm HIP runtime symlinks
# for GPU compute and graphics acceleration.
{
  extraLib,
  pkgs,
  ...
} @ args:
extraLib.modules.mkModule args {
  name = "drivers.amdgpu";
  hasGui = false;

  # --- Driver Configuration ---
  cliConfig = {
    # X11 / Wayland video driver
    services.xserver.videoDrivers = ["amdgpu"];

    # ROCm HIP runtime compatibility symlink
    systemd.tmpfiles.rules = [
      "L+ /opt/rocm/hip - - - - ${pkgs.rocmPackages.clr}"
    ];
  };
}
