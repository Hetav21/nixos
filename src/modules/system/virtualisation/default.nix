{
  lib,
  config,
  ...
}: {
  # --- Submodules ---
  imports = [
    ./android.nix
    ./binfmt.nix
    ./docker.nix
    ./libvirtd.nix
    ./podman.nix
    ./virt-manager.nix
    ./waydroid.nix
  ];

  # --- Options ---
  options.system.virtualisation = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable virtualization CLI components";
    };
    enableGui = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable virtualization GUI components";
    };
  };

  # --- Configuration ---
  config = lib.mkMerge [
    (lib.mkIf config.system.virtualisation.enable {
      system.virtualisation.android.enable = lib.mkDefault true;
      system.virtualisation.binfmt.enable = lib.mkDefault true;
      system.virtualisation.docker.enable = lib.mkDefault true;
      system.virtualisation.libvirtd.enable = lib.mkDefault true;
      system.virtualisation.podman.enable = lib.mkDefault true;
    })
    (lib.mkIf config.system.virtualisation.enableGui {
      system.virtualisation.virt-manager.enableGui = lib.mkDefault true;
      system.virtualisation.waydroid.enableGui = lib.mkDefault true;
    })
  ];
}
