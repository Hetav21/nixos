{
  extraLib,
  pkgs,
  config,
  hardware,
  ...
} @ args:
extraLib.modules.mkModule args {
  name = "drivers.nvidia";
  hasGui = false;
  cliConfig = {
    # --- Nvidia Packages & Containers ---
    hardware.nvidia-container-toolkit.enable = true;

    environment.systemPackages = [
      pkgs.cudaPackages.cudatoolkit
    ];

    # --- Video Acceleration & Display Server ---
    hardware.graphics = {
      extraPackages = [
        pkgs.nvidia-vaapi-driver
        pkgs.libvdpau-va-gl
      ];
    };

    services.xserver.videoDrivers = ["nvidia"];

    # --- Kernel Parameters & Nvidia Settings ---
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
}
