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
      autoStart = true;
      capSysAdmin = true;
      openFirewall = true;
    };

    # --- User Permissions & High Priority Scheduling ---
    users.users.${settings.username}.extraGroups = ["uinput"];
    security.wrappers.sunshine.capabilities = "cap_sys_admin,cap_sys_nice+p";
  };
}
