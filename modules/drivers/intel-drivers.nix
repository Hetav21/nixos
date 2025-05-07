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
    hardware.graphics = {
      extraPackages = with pkgs; [
        intel-media-driver
        intel-vaapi-driver
      ];

      extraPackages32 = with pkgs.pkgsi686Linux; [
        intel-vaapi-driver
      ];
    };
  };
}
