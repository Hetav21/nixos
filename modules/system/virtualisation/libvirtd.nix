{
  extraLib,
  pkgs,
  settings,
  ...
} @ args:
extraLib.modules.mkModule args {
  name = "system.virtualisation.libvirtd";
  hasCli = true;
  hasGui = false;
  cliConfig = {
    # --- Libvirtd Service ---
    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = false;
        swtpm.enable = true;
      };
      extraConfig = ''firewall_backend = "nftables"'';
    };

    # --- User Groups ---
    users.users.${settings.username}.extraGroups = ["libvirtd" "kvm"];

    # --- Firmware Symlinks ---
    systemd.tmpfiles.rules = [
      "L+ /var/lib/qemu/firmware - - - - ${pkgs.qemu}/share/qemu/firmware"
    ];
  };
}
