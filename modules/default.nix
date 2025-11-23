# NixOS Module System
#
# Namespace Organization:
# - system.*     : System-level configuration (packages, services, system settings)
# - home.*       : Home-manager user-level configuration (dotfiles, user packages)
# - drivers.*    : Hardware driver configuration (nvidia, amd, intel, asus)
# - profiles.*   : Pre-configured bundles of modules for different use cases
#
# User Groups Added by Modules:
# - system.desktop.services: mlocate
# - system.desktop.virtualisation: libvirtd, kvm, adbusers, docker
# - system.desktop.network-tools: networkmanager, wireshark

{...}: {
  imports = [
    ./system
    ./drivers
  ];
}
