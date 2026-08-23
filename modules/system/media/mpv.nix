{
  extraLib,
  pkgs,
  ...
} @ args:
extraLib.modules.mkModule args {
  name = "system.media.mpv";
  hasCli = true;
  hasGui = false;
  cliConfig = {
    # --- MPV Media Player ---
    environment.systemPackages = [
      pkgs.mpv
    ];
  };
}
