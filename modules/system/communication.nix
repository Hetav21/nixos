{
  lib,
  pkgs,
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
    environment.systemPackages = with pkgs; [
      # Communication and social
      unstable.thunderbird
      unstable.discord
      unstable.vesktop
      zoom-us
    ];
  };
}

