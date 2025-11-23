{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.system.desktop.appimage;
in {
  options.system.desktop.appimage = {
    enable = mkEnableOption "Enable AppImage support configuration";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [appimage-run];

    programs.fuse.userAllowOther = true;

    programs.appimage = {
      enable = true;
      binfmt = true;
    };
  };
}
