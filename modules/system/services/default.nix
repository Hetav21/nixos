{
  lib,
  config,
  ...
}: {
  imports = [
    ./locate.nix
    ./cron.nix
    ./gnupg.nix
    ./flatpak.nix
  ];

  options = {
    system.baseservices = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable essential base services (locate, cron, gnupg)";
      };
      enableGui = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable base GUI services (flatpak)";
      };
    };
  };

  config = {
    system.baseservices.locate.enable = lib.mkDefault config.system.baseservices.enable;
    system.baseservices.cron.enable = lib.mkDefault config.system.baseservices.enable;
    system.baseservices.gnupg.enable = lib.mkDefault config.system.baseservices.enable;

    system.baseservices.flatpak.enableGui = lib.mkDefault config.system.baseservices.enableGui;
  };
}
