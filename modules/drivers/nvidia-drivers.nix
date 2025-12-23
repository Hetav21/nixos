{
  extraLib,
  pkgs,
  config,
  hardware,
  ...
} @ args:
(extraLib.modules.mkModule {
  name = "drivers.nvidia";
  hasGui = false;
  cliConfig = _: {
    hardware.nvidia-container-toolkit.enable = true;

    environment.systemPackages = [
      pkgs.cudaPackages.cudatoolkit
      # pkgs.cudaPackages.cudnn
    ];

    hardware.graphics = {
      extraPackages = [
        pkgs.nvidia-vaapi-driver
        pkgs.libvdpau-va-gl
      ];
    };

    services.xserver.videoDrivers = ["nvidia"];

    boot.kernelParams = [
      "nvidia-drm.modeset=1"
      "nvidia-drm.fbdev=1"
    ];

    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement = {
        enable = true;
        finegrained = false;
      };
      open = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.${hardware.nvidia.package};
    };
  };
})
args
