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
      # vim - replaced by neovim via nixCats (provides vim/vi/nvim aliases)
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
