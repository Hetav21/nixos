{
  extraLib,
  pkgs,
  ...
} @ args:
extraLib.modules.mkModule args {
  name = "system.virtualisation.podman";
  cliConfig = {
    # --- Packages ---
    environment.systemPackages = [
      # pkgs.podman-compose # Compose specification runner for Podman
    ];

    # --- Container Runtime ---
    virtualisation = {
      containers.enable = true;
      podman = {
        enable = true;
        dockerCompat = false;
        defaultNetwork.settings.dns_enabled = true;
      };
    };
  };
}
