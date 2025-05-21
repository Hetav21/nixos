{...}: {
  imports = [
    ./units/mute-on-boot.nix
    ./units/rclone-mount.nix
    ./units/flatpak-update.nix
    ./units/localsend.nix
    ./units/mega-sync.nix
    ./units/onedrive.nix
    ./units/network-online-user.nix
  ];
}
