{
  extraLib,
  settings,
  ...
} @ args:
extraLib.modules.mkModule args {
  name = "system.media.sunshine";
  hasCli = true;
  hasGui = false;
  cliConfig = {
    # --- Sunshine Game & Desktop Streaming Service ---
    services.sunshine = {
      enable = true;
      autoStart = false;
      capSysAdmin = true;
      openFirewall = true;
    };

    # --- User Permissions ---
    users.users.${settings.username}.extraGroups = ["uinput"];
  };
}
