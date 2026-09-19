# NVIDIA Proprietary Driver & Acceleration Module
#
# Configures proprietary NVIDIA drivers, kernel mode-setting, power management,
# hardware video acceleration, CUDA toolkit, container runtime, and imports PRIME submodules.
{
  extraLib,
  pkgs,
  config,
  lib,
  ...
} @ args:
extraLib.modules.mkModule args {
  name = "drivers.nvidia";
  hasGui = false;
  imports = [
    ./prime
  ];

  # --- Declarative Module Options ---
  extraOptions = {
    drivers.nvidia = {
      package = lib.mkOption {
        type = lib.types.str;
        default = "stable";
        description = "NVIDIA driver package channel (stable, beta, production, etc.).";
      };
    };
  };

  # --- Driver Configuration ---
  cliConfig = {
    # --- Kernel Parameters & DRM Modesetting ---
    boot.kernelParams = [
      "nvidia-drm.modeset=1"
      "nvidia-drm.fbdev=1"
    ];

    # --- Display Server Video Driver ---
    services.xserver.videoDrivers = ["nvidia"];

    # --- Hardware Driver Settings ---
    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement = {
        enable = true;
        finegrained = false;
      };
      open = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.${config.drivers.nvidia.package};
    };

    # --- Hardware Video Acceleration ---
    hardware.graphics = {
      extraPackages = [
        pkgs.nvidia-vaapi-driver
        pkgs.libvdpau-va-gl
      ];
    };

    # --- Container & Compute Tooling ---
    hardware.nvidia-container-toolkit.enable = true;

    environment.systemPackages = [
      pkgs.cudaPackages.cudatoolkit
    ];
  };
}
