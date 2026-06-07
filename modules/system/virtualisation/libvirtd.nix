{
  extraLib,
  pkgs,
  settings,
  ...
} @ args:
(extraLib.modules.mkModule {
  name = "system.virtualisation.libvirtd";
  hasCli = true;
  hasGui = false;
  cliConfig = {
    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = false;
        swtpm.enable = true;
      };
      extraConfig = ''firewall_backend = "nftables"'';
    };

    users.users.${settings.username}.extraGroups = ["libvirtd" "kvm"];

    systemd.tmpfiles.rules = [
      "L+ /var/lib/qemu/firmware - - - - ${pkgs.qemu}/share/qemu/firmware"
    ];
  };
})
args
