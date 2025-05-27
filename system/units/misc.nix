{pkgs, ...}: {
  services = {
    locate = {
      enable = true;
      package = pkgs.mlocate;
    };

    cron = {enable = true;};
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  imports = [../../systemd/systemd-extra-imports.nix];

  systemd.extra = {muteMicrophone.enable = true;};
}
