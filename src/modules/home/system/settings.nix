{
  extraLib,
  pkgs,
  ...
} @ args:
extraLib.modules.mkModule args {
  name = "home.system.settings";
  hasCli = true;
  hasGui = false;

  cliConfig = {
    # --- Packages & Tools ---
    home.packages = [
      pkgs.alejandra
      pkgs.nixd
      pkgs.nil
    ];

    # --- Nix Index & Database ---
    programs.nix-index.enable = true;
    programs.nix-index-database.comma.enable = true;
  };
}
