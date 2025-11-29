{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.home.nix-settings;
in {
  options.home.nix-settings = {
    enable = mkEnableOption "Enable Nix development tools and utilities";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # Nix formatters
      alejandra
      # nixfmt-classic

      # Nix language servers
      nixd
      nil
    ];

    programs = {
      nix-index.enable = true;
      nix-index-database.comma.enable = true;
    };
  };
}
