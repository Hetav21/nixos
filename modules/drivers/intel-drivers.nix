{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.drivers.intel;
in {
  options.drivers.intel = {
    enable = mkEnableOption "Enable Intel Graphics Drivers";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      # Top
      nvtopPackages.intel
    ];

    hardware.graphics = {
      extraPackages = with pkgs; [
        intel-media-driver
        vpl-gpu-rt
        libvdpau-va-gl
        vaapiVdpau
      ];

      extraPackages32 = with pkgs.pkgsi686Linux; [
        intel-media-driver
      ];
    };
  };
}
