{
  extraLib,
  pkgs-unstable,
  ...
} @ args:
extraLib.modules.mkModule args {
  name = "system.communication.discord";
  hasCli = false;
  hasGui = true;
  guiConfig = {
    # --- Discord Clients ---
    environment.systemPackages = [
      pkgs-unstable.discord
      pkgs-unstable.vesktop
    ];
  };
}
