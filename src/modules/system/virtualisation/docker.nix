{
  extraLib,
  pkgs,
  settings,
  ...
} @ args:
extraLib.modules.mkModule args {
  name = "system.virtualisation.docker";
  cliConfig = {
    # --- Packages ---
    environment.systemPackages = [
      pkgs.dive
      pkgs.docker-compose
    ];

    # --- User Groups ---
    users.users.${settings.username}.extraGroups = ["docker"];

    # --- Docker Daemon ---
    virtualisation.docker = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
  };
}
