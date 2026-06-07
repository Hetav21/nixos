{
  lib,
  config,
  ...
}: {
  imports = [
    ./base.nix
    ./applet.nix
    ./wireshark.nix
  ];

  options = {
    system.network = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable base networking services";
      };
      enableGui = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable all GUI networking tools (applet, wireshark)";
      };
    };
  };

  config = {
    system.network.base.enable = lib.mkDefault config.system.network.enable;
    system.network.applet.enableGui = lib.mkDefault config.system.network.enableGui;
    system.network.wireshark.enableGui = lib.mkDefault config.system.network.enableGui;
  };
}
