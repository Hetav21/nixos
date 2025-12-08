{
  lib,
  pkgs,
  config,
  hardware,
  ...
}:
with lib; let
  cfg = hardware.nvidia;
in {
  options.drivers.nvidia = {
    enable = mkEnableOption "Enable Nvidia Drivers";
  };

  config = mkIf cfg.enable {
    hardware.nvidia-container-toolkit.enable = true;

    environment.systemPackages = with pkgs; [
      cudaPackages.cudatoolkit
      # cudaPackages.cudnn
    ];

    hardware.graphics = {
      extraPackages = with pkgs; [
        nvidia-vaapi-driver
        libvdpau-va-gl
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
      package = config.boot.kernelPackages.nvidiaPackages.${cfg.package};
    };
  };
}
