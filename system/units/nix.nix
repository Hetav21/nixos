{pkgs, ...}: let
  username = "hetav";
in {
  environment.systemPackages = with pkgs; [
    nixfmt-rfc-style
    nix-index
    cachix
    nixd
  ];

  programs = {
    nix-index.enable = true;
    nix-index-database.comma.enable = true;
  };

  nix = {
    settings = {
      trusted-users = [
        "root"
        "${username}"
      ];
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
      stalled-download-timeout = 99999999;
      max-jobs = 2;
      cores = 8;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
}
