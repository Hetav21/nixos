{
  extraLib,
  pkgs,
  ...
} @ args:
(extraLib.modules.mkModule {
  name = "drivers.amdgpu";
  hasGui = false;
  cliConfig = _: {
    systemd.tmpfiles.rules = ["L+ /opt/rocm/hip - - - - ${pkgs.rocmPackages.clr}"];
    services.xserver.videoDrivers = ["amdgpu"];
  };
})
args
