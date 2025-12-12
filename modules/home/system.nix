{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.home.system;
in {
  options.home.system = {
    enable = mkEnableOption "Enable CLI/TUI system utilities";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # System monitoring and utilities
      btop
      killall
      most
      vim

      # System information tools
      tree
      fastfetch
      microfetch
      onefetch

      # Filesystem support
      ntfs3g

      # Misc
      typioca
    ];
  };
}
