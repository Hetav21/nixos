# ASUS-specific hardware support (asusd, supergfxd, rog-control-center)
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
      # supergfxd controls GPU switching
      supergfxd.enable = true;

      # ASUS specific software. This also installs asusctl.
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
