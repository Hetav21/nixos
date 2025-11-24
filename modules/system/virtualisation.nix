{
  lib,
  pkgs,
  config,
  settings,
  ...
}:
with lib; let
  cfg = config.system.virtualisation;
in {
  options.system.virtualisation = {
    enable = mkEnableOption "Enable CLI/TUI virtualisation tools (Docker, Podman)";
    enableGui = mkEnableOption "Enable GUI virtualisation tools (virt-manager, quickgui, waydroid)";
  };

  config = mkMerge [
    # CLI/TUI virtualisation tools
    (mkIf cfg.enable {
      environment.systemPackages = with pkgs; [
        dive # Docker image explorer (TUI)
        docker-compose
        podman-compose
      ];

      boot.binfmt.emulatedSystems = ["aarch64-linux" "riscv64-linux"];

      users.users.${settings.username}.extraGroups = ["docker"];

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
      };
    })

    # GUI virtualisation tools
    (mkIf cfg.enableGui {
      # Auto-enable CLI tools when GUI is enabled
      system.virtualisation.enable = true;

      environment.systemPackages = with pkgs; [
        virt-manager
        quickemu
        quickgui
      ];

      users.users.${settings.username}.extraGroups = ["libvirtd" "kvm" "adbusers"];

      systemd.tmpfiles.rules = ["L+ /var/lib/qemu/firmware - - - - ${pkgs.qemu}/share/qemu/firmware"];

      virtualisation = {
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

          # Ensure libvirt uses a compatible firewall backend
          extraConfig = "firewall_backend = \"nftables\"";
        };

        spiceUSBRedirection.enable = true;
      };

      programs = {
        adb.enable = true;
        virt-manager.enable = true;
        dconf.enable = true;
      };

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
    })
  ];
}
