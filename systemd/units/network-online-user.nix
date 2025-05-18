{pkgs, ...}: let
in {
  systemd.user.services = {
    networkd-wait-online = {
      enable = true;
      description = "User Wait for Network to be Configured";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.systemd}/lib/systemd/systemd-networkd-wait-online";
        RemainAfterExit = "yes";
      };
    };
  };
}
