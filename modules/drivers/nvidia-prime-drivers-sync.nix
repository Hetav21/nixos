{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.drivers.nvidia-prime.sync;
in {
  options.drivers.nvidia-prime.sync = {
    enable = mkEnableOption "Enable Nvidia Prime Hybrid GPU Sync";
    intelBusID = mkOption {
      type = types.str;
      default = "PCI:0:02:0";
    };
    nvidiaBusID = mkOption {
      type = types.str;
      default = "PCI:1:00:0";
    };
  };

  config = mkIf cfg.enable {
    hardware.nvidia = {
      prime = {
        sync.enable = true;
        intelBusId = "${cfg.intelBusID}";
        nvidiaBusId = "${cfg.nvidiaBusID}";
      };
    };
  };
}
