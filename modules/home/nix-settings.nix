{
  extraLib,
  lib,
  pkgs,
  ...
} @ args:
(extraLib.modules.mkModule {
  name = "home.nix-settings";
  hasGui = false;
  cliConfig = _: {
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
})
args
