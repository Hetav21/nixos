{
  lib,
  pkgs,
  pkgs-unstable,
  config,
  ...
}:
with lib; let
  cfg = config.system.communication;
in {
  options.system.communication = {
    enableGui = mkEnableOption "Enable GUI communication tools (discord, thunderbird, zoom)";
  };

  config = mkIf cfg.enableGui {
    environment.systemPackages =
      (with pkgs; [
        zoom-us
      ])
      ++ (with pkgs-unstable; [
        # Communication and social
        thunderbird
        discord
        vesktop
      ]);
  };
}
