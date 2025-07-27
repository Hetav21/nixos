{
  lib,
  hardware,
  ...
}:
with lib; let
  cfg = hardware.asus;
in {
  options.drivers.asus = {
    enable = mkEnableOption "Enable Asus Specific Features";
  };

  config = mkIf cfg.enable {
    services = {
      supergfxd.enable = true;

      asusd = {
        enable = true;
        enableUserService = true;
      };
    };

    programs = {
      rog-control-center = {
        enable = true;
        autoStart = true;
      };
    };
  };
}
