{
  config,
  lib,
  pkgs,
  inputs,
  options,
  ...
}: let
in {
  systemd = {
    #    targets = {
    #      sleep = {
    #        enable = true;
    #        unitConfig.DefaultDependencies = "yes";
    #      };
    #      suspend = {
    #        enable = false;
    #        unitConfig.DefaultDependencies = "no";
    #      };
    #      hibernate = {
    #        enable = false;
    #        unitConfig.DefaultDependencies = "no";
    #      };
    #      "hybrid-sleep" = {
    #        enable = false;
    #        unitConfig.DefaultDependencies = "no";
    #      };
    #    };

    services = {
      ###  To disable a systemd service:
      ##   <service-name>.wantedBy = lib.mkForce [ ];
    };
  };
}
