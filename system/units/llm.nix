{
  config,
  lib,
  pkgs,
  inputs,
  options,
  ...
}: let
  username = "hetav";
in {
  environment.systemPackages = with pkgs; [
    ollama
    open-webui
  ];

  services = {
    ollama = {
      enable = true;
      acceleration = "cuda";
    };

    open-webui = {
      enable = true;
      openFirewall = true;
      # stateDir = "/home/hetav/.open-webui";
      environment = {
        ANONYMIZED_TELEMETRY = "False";
        DO_NOT_TRACK = "True";
        SCARF_NO_ANALYTICS = "True";
      };
    };
  };
}
