{
  pkgs,
  settings,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # nixfmt-classic
    nix-index
    alejandra
    cachix
    nixd
    nil
  ];

  programs = {
    nix-index.enable = true;
    nix-index-database.comma.enable = true;
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
  };
}
