{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    virt-viewer
    virt-manager
    spice
    spice-gtk
    spice-protocol
    win-virtio
    win-spice
    adwaita-icon-theme

    dive
    docker-compose
    podman-compose
    quickemu
    quickgui
  ];

  boot.binfmt.emulatedSystems = ["aarch64-linux" "riscv64-linux"];

  programs.adb.enable = true;
  programs.virt-manager.enable = true;

  users.groups.libvirtd.members = ["hetav"];

  users.users.hetav.extraGroups = ["libvirtd" "kvm" "adbusers"];

  services.udev.packages = with pkgs; [android-udev-rules];

  programs.dconf.enable = true;

  systemd.tmpfiles.rules = ["L+ /var/lib/qemu/firmware - - - - ${pkgs.qemu}/share/qemu/firmware"];

  virtualisation = {
    # Enable common container config files in /etc/containers
    containers.enable = true;

    podman = {
      enable = true;

      # Using docker instead of creating docker alias for podman
      dockerCompat = false;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };

    docker = {
      enable = true;

      # Enabling docker in rootless mode
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };

    waydroid.enable = true;

    libvirtd = {
      enable = true;

      qemu = {
        swtpm.enable = true;
        ovmf.enable = true;
        ovmf.packages = [pkgs.OVMFFull.fd];
      };
    };

    spiceUSBRedirection.enable = true;
  };

  services.spice-vdagentd.enable = true;
}
