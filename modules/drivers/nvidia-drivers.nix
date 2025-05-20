{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.drivers.nvidia;
in {
  options.drivers.nvidia = {
    enable = mkEnableOption "Enable Nvidia Drivers";
  };

  config = mkIf cfg.enable {
    hardware.nvidia-container-toolkit.enable = true;

    environment.systemPackages = with pkgs; [
      # Top
      nvtopPackages.nvidia

      # CUDA
      cudaPackages.cudatoolkit
      cudaPackages.cudnn
    ];

    hardware.graphics = {
      enable = true;
      enable32Bit = true;

      extraPackages = with pkgs; [
        nvidia-vaapi-driver
        libvdpau-va-gl
      ];
    };

    nix.settings = {
      substituters = [
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };

    services.xserver.videoDrivers = ["nvidia"];

    boot.kernelParams = [
      "nvidia-drm.modeset=1"
      "nvidia-drm.fbdev=1"
    ];

    nixpkgs.config = {
      packageOverrides = _: {inherit (pkgs) linuxPackages_latest nvidia_x11;};
    };

    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement = {
        enable = true;
        finegrained = false;
      };
      open = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.latest;
    };
  };
}
