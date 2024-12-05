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
    ##    nixpkgs.config.packageOverrides = pkgs: {
    ##      vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
    ##    };

    # OpenGL
    hardware.graphics = {
      extraPackages = with pkgs; [
        mesa.drivers
        libva
        vpl-gpu-rt
        intel-media-driver
        intel-vaapi-driver
        ##	vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
      ];
    };

    # Force intel-media-driver
    # environment.sessionVariables = {LIBVA_DRIVER_NAME = "iHD";};
  };
}
