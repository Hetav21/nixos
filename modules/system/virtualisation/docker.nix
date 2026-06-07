{
  extraLib,
  pkgs,
  settings,
  ...
} @ args:
(extraLib.modules.mkModule {
  name = "system.virtualisation.docker";
  cliConfig = {
    environment.systemPackages = with pkgs; [
      dive
      docker-compose
    ];

    users.users.${settings.username}.extraGroups = ["docker"];

    virtualisation.docker = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
  };
})
args
