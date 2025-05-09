{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.drivers.nvidia-prime.offload;
in {
  options.drivers.nvidia-prime.offload = {
    enable = mkEnableOption "Enable Nvidia Prime Hybrid GPU Offload";
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
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        intelBusId = "PCI:0:02:0";
        nvidiaBusId = "PCI:1:00:0";
      };
    };
  };
}
