{
  lib,
  config,
  ...
}: {
  imports = [
    ./zoom.nix
    ./thunderbird.nix
    ./discord.nix
  ];

  options = {
    system.communication = {
      enableGui = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable all GUI communication applications";
      };
    };
  };

  config = {
    system.communication.zoom.enableGui = lib.mkDefault config.system.communication.enableGui;
    system.communication.thunderbird.enableGui = lib.mkDefault config.system.communication.enableGui;
    system.communication.discord.enableGui = lib.mkDefault config.system.communication.enableGui;
  };
}
