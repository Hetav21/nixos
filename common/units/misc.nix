{
  config,
  lib,
  pkgs,
  inputs,
  options,
  ...
}: let
in {
  services = {
    locate = {
      enable = true;
      package = pkgs.mlocate;
    };

    cron = {
      enable = true;
    };

    gnome.gnome-keyring.enable = true;
  };

  programs = {
    dconf.enable = true;

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  imports = [
    ../../systemd/systemd-extra-imports.nix
  ];

  systemd.extra = {
    muteMicrophone.enable = true;
  };
}
