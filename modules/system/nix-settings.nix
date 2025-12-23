{
  extraLib,
  pkgs,
  settings,
  ...
} @ args:
(extraLib.modules.mkModule {
  name = "system.nix.settings";
  hasGui = false;
  cliConfig = _: {
    environment.systemPackages = [
      pkgs.nix-update
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
})
args
