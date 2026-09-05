{
  extraLib,
  pkgs,
  ...
} @ args:
extraLib.modules.mkModule args {
  name = "home.system.packages";
  hasCli = true;
  hasGui = false;

  cliConfig = {
    # --- System Packages ---
    home.packages = [
      # System monitoring and utilities
      pkgs.btop
      pkgs.killall
      pkgs.most
      pkgs.wget

      # System information tools
      pkgs.tree
      pkgs.fastfetch
      pkgs.microfetch
      pkgs.onefetch

      # Filesystem support
      pkgs.ntfs3g
    ];
  };
}
