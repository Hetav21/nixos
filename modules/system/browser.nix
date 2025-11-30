{
  lib,
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
    services.flatpak.packages = [
      "com.microsoft.Edge"
    ];
  };
}
