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

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  imports = [
    ../../systemd/systemd-extra-imports.nix
  ];

  systemd.extra = {
    muteMicrophone.enable = true;
  };
}
