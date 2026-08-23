{
  extraLib,
  pkgs,
  ...
} @ args:
extraLib.modules.mkModule args {
  name = "system.desktop.appimage";
  hasGui = false;
  cliConfig = {
    # --- AppImage & FUSE Support ---
    environment.systemPackages = [pkgs.appimage-run];

    programs.fuse.userAllowOther = true;

    programs.appimage = {
      enable = true;
      binfmt = true;
    };
  };
}
