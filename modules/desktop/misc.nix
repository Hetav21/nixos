{
  pkgs,
  settings,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # Shell and terminal utilities
    killall
    most
    vim

    # System monitoring and management
    btop

    # System utilities

    # File systems
    ntfs3g
  ];

  services = {
    # Nix-Flatpak
    flatpak = {
      enable = true;
      package = pkgs.flatpak;
      uninstallUnmanaged = true;
      update.auto = {
        enable = true;
        onCalendar = "daily";
      };
      overrides = {
        global = {
          Environment = {
            LIBVA_DRIVER_NAME = "nvidia";
            ELECTRON_OZONE_PLATFORM_HINT = "wayland";
          };
        };
      };
      packages = [
        "io.github.flattool.Warehouse" # Flatpak Manager
        "com.github.tchx84.Flatseal" # Flatpak Permissions Manager
      ];
    };

    preload.enable = true;

    locate = {
      enable = true;
      package = pkgs.mlocate;
    };

    cron = {enable = true;};
  };

  users.users.${settings.username}.extraGroups = ["mlocate"];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
}
