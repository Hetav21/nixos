{
  extraLib,
  pkgs,
  ...
} @ args:
extraLib.modules.mkModule args {
  name = "drivers.amdgpu";
  hasGui = false;
  cliConfig = {
    # --- AMD ROCm & Video Drivers ---
    systemd.tmpfiles.rules = ["L+ /opt/rocm/hip - - - - ${pkgs.rocmPackages.clr}"];
    services.xserver.videoDrivers = ["amdgpu"];
  };
}
