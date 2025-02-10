{
  config,
  lib,
  pkgs,
  inputs,
  options,
  ...
}: let
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
    };
  };
}
