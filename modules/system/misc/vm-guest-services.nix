{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.system.virtualization.guest;
in {
  options.system.virtualization.guest = {
    enable = mkEnableOption "Enable Virtual Machine Guest Services";
  };

  config = mkIf cfg.enable {
    services.qemuGuest.enable = true;
    services.spice-vdagentd.enable = true;
    services.spice-webdavd.enable = true;
  };
}
