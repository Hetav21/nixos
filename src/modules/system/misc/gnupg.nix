{
  extraLib,
  pkgs,
  ...
} @ args:
extraLib.modules.mkModule args {
  name = "system.misc.gnupg";
  hasCli = true;
  hasGui = false;
  cliConfig = {
    # --- GnuPG Agent ---
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      # Keep the passphrase for a working day.
      settings = {
        default-cache-ttl = 36000;
        max-cache-ttl = 36000;
      };
    };

    # --- Password Store ---
    environment.systemPackages = [pkgs.pass];
  };
}
