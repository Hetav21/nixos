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
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
}
