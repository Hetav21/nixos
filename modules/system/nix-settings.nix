{
  lib,
  pkgs,
  config,
  settings,
  ...
}:
with lib; let
  cfg = config.system.nix.settings;
in {
  options.system.nix.settings = {
    enable = mkEnableOption "Enable nix settings configuration";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      nix-update
    ];

    nix = {
      settings = {
        trusted-users = ["root" "${settings.username}"];
        auto-optimise-store = true;
        experimental-features = ["nix-command" "flakes"];
        stalled-download-timeout = 99999999;
        max-jobs = settings.nix.maxJobs or 2;
        cores = settings.nix.cores or 8;
      };
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
        persistent = true;
      };
      optimise = {
        automatic = true;
        dates = ["weekly"];
      };
    };
  };
}
