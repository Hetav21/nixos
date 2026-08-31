{
  extraLib,
  ...
} @ args:
extraLib.modules.mkCategoryModule args {
  name = "system.virtualisation";
  imports = [
    ./android.nix
    ./binfmt.nix
    ./docker.nix
    ./guest.nix
    ./libvirtd.nix
    ./podman.nix
    ./virt-manager.nix
    ./waydroid.nix
  ];
  hasCli = true;
  cliDescription = "Enable virtualization CLI components";
  cliChildren = [
    "android"
    "binfmt"
    "docker"
    "guest"
    "libvirtd"
    "podman"
  ];
  hasGui = true;
  guiDescription = "Enable virtualization GUI components";
  guiChildren = [
    "virt-manager"
    "waydroid"
  ];
}
