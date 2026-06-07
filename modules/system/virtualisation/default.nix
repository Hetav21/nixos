{
  lib,
  config,
  ...
}: {
  imports = [
    ./docker.nix
    ./podman.nix
    ./libvirtd.nix
    ./virt-manager.nix
    ./waydroid.nix
    ./binfmt.nix
    ./android.nix
  ];

  # Compatibility options for existing profiles
  options.system.virtualisation = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Meta-option to enable virtualization (CLI/TUI components)";
    };
    enableGui = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Meta-option to enable virtualization GUI components";
    };
  };

  config = lib.mkMerge [
    # When system.virtualisation.enable is true, default-enable CLI components
    (lib.mkIf config.system.virtualisation.enable {
      system.virtualisation.docker.enable = lib.mkDefault true;
      system.virtualisation.podman.enable = lib.mkDefault true;
      system.virtualisation.libvirtd.enable = lib.mkDefault true;
      system.virtualisation.binfmt.enable = lib.mkDefault true;
      system.virtualisation.android.enable = lib.mkDefault true;
    })
    # When system.virtualisation.enableGui is true, default-enable GUI components
    (lib.mkIf config.system.virtualisation.enableGui {
      system.virtualisation.virt-manager.enableGui = lib.mkDefault true;
      system.virtualisation.waydroid.enableGui = lib.mkDefault true;
    })
  ];
}
