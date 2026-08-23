{extraLib, ...} @ args:
extraLib.modules.mkModule args {
  name = "system.baseservices.gnupg";
  hasCli = true;
  hasGui = false;
  cliConfig = {
    # --- GnuPG Agent ---
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };
}
