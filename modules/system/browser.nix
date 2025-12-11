{
  lib,
  pkgs,
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
    environment.systemPackages = with pkgs; [
      custom.browseros
      unstable.brave
      unstable.google-chrome
    ];

    services.flatpak.packages = [
      "com.microsoft.Edge"
    ];
  };
}
