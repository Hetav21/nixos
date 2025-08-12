{
  pkgs,
  settings,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # virt-viewer
    # spice
    # spice-gtk
    # spice-protocol
    # win-virtio
    # win-spice
    # adwaita-icon-theme
    virt-manager

    dive
    docker-compose
    podman-compose
    quickemu
    quickgui
  ];

  boot.binfmt.emulatedSystems = ["aarch64-linux" "riscv64-linux"];

  users.users.${settings.username}.extraGroups = ["libvirtd" "kvm" "adbusers" "docker"];

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
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [
            (pkgs.OVMF.override {
              secureBoot = true;
              tpmSupport = true;
            }).fd
          ];
        };
      };

      # Ensure libvirt uses a compatible firewall backend. nftables is the modern default.
      extraConfig = "firewall_backend = \"nftables\"";
    };

    spiceUSBRedirection.enable = true;
  };

  programs = {
    adb.enable = true;
    virt-manager.enable = true;
    dconf.enable = true;
  };

  # dconf.settings = {
  #   "org/virt-manager/virt-manager/connections" = {
  #     autoconnect = ["qemu:///system"];
  #     uris = ["qemu:///system"];
  #   };
  # };

  services = {
    spice-vdagentd.enable = true;
    spice-webdavd = {
      enable = true;
      package = pkgs.phodav;
    };
    spice-autorandr = {
      enable = true;
      package = pkgs.spice-autorandr;
    };

    udev.packages = with pkgs; [android-udev-rules];
  };
}
