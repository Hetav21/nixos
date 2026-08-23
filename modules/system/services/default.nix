{
  lib,
  config,
  ...
}: {
  # --- Submodules ---
  imports = [
    ./cron.nix
    ./flatpak.nix
    ./gnupg.nix
    ./locate.nix
  ];

  # --- Options ---
  options.system.baseservices = {
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

  # --- Configuration ---
  config = {
    system.baseservices.cron.enable = lib.mkDefault config.system.baseservices.enable;
    system.baseservices.gnupg.enable = lib.mkDefault config.system.baseservices.enable;
    system.baseservices.locate.enable = lib.mkDefault config.system.baseservices.enable;

    system.baseservices.flatpak.enableGui = lib.mkDefault config.system.baseservices.enableGui;
  };
}
