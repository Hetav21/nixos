{
  lib,
  pkgs,
  pkgs-unstable,
  config,
  ...
}:
with lib; let
  cfg = config.system.browser;
in {
  options.system.browser = {
    enableGui = mkEnableOption "Enable GUI web browsers";
  };

  config = mkIf cfg.enableGui {
    environment.systemPackages =
      (with pkgs; [
        custom.browseros
      ])
      ++ (with pkgs-unstable; [
        brave
        google-chrome
      ]);

    services.flatpak.packages = [
      "com.microsoft.Edge"
    ];
  };
}
