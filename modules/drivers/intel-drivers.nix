{
  lib,
  pkgs,
  hardware,
  ...
}:
with lib; let
  cfg = hardware.intel;
in {
  options.drivers.intel = {
    enable = mkEnableOption "Enable Intel Graphics Drivers";
  };

  config = mkIf cfg.enable {
    hardware.graphics = {
      extraPackages = with pkgs; [
        intel-media-driver
        vpl-gpu-rt
        libvdpau-va-gl
        libva-vdpau-driver
      ];

      extraPackages32 = with pkgs.pkgsi686Linux; [intel-media-driver];
    };
  };
}
