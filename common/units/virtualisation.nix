{
  config,
  lib,
  pkgs,
  inputs,
  options,
  ...
}: let
in {
  virtualisation = {
    podman = {
      enable = true;
      #  dockerCompat = true;
    };
    docker = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
    waydroid.enable = true;
  };
  environment.systemPackages = with pkgs; [
    libvirt
  ];
}
