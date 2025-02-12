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
    libvirt
    virt-viewer
  ];

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
}
