{
  extraLib,
  lib,
  pkgs,
  ...
} @ args:
(extraLib.modules.mkModule {
  name = "home.system";
  hasGui = false;
  cliConfig = _: {
    home.packages = with pkgs; [
      # System monitoring and utilities
      btop
      killall
      most
      vim
      wget

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
})
args
