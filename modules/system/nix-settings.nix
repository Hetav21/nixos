{
  lib,
  pkgs,
  inputs,
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
      cachix
    ];

    system.autoUpgrade = {
      enable = true;
      flake = inputs.self.outPath;
      flags = [
        "--update-input"
        "${settings.update-standard}"
        "-L" # print build logs
      ];
      dates = "09:00";
      randomizedDelaySec = "45min";
    };

    nix = {
      settings = {
        trusted-users = ["root" "${settings.username}"];
        auto-optimise-store = true;
        experimental-features = ["nix-command" "flakes"];
        stalled-download-timeout = 99999999;
        max-jobs = 2;
        cores = 8;
        substituters = [
          "https://nix-community.cachix.org"
        ];
        trusted-substituters = [
          "https://nix-community.cachix.org"
        ];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
      };
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };
      optimise = {
        automatic = true;
        dates = ["weekly"];
      };
    };
  };
}
