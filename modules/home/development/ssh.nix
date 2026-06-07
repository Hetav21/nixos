{extraLib, ...} @ args:
(extraLib.modules.mkModule {
  name = "home.development.ssh";
  hasCli = true;
  hasGui = false;
  cliConfig = _: {
    services.ssh-agent.enable = true;

    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      # Note: github.com-personal/work aliases removed - Git now uses
      # directory-based SSH key selection via core.sshCommand in git includes
      settings = {
        "*" = {
          forwardAgent = false;
          addKeysToAgent = "yes";
          compression = false;
          serverAliveInterval = 0;
          serverAliveCountMax = 3;
          hashKnownHosts = false;
          userKnownHostsFile = "~/.ssh/known_hosts";
          controlMaster = "auto";
          controlPath = "~/.ssh/master-%r@%n:%p";
          controlPersist = "10m";
        };
      };
    };
  };
})
args
