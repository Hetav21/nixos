# nixbook host-specific settings
# These are merged with common.nix using hostLib.mkHostSettings
{
  hostname = "nixbook";
  wallpaper = "China.jpeg";

  # Inputs specific to nixbook (desktop)
  inputs = {
    standard = [
      "lanzaboote"
      "nix-flatpak"
      "zen-browser"
      "claude-subagents"
      "superpowers"
    ];
    latest = [
      "vicinae-extensions"
      "nixCats"
    ];
  };

  # Build configuration for physical hardware
  nix = {
    maxJobs = 4;
    cores = 8;
  };

  rclone = {
    enable = false;
    local_dir = "";
    remote_dir = "";
  };

  # SSH key configuration
  ssh = {
    work.identityFile = "";
    personal.identityFile = "~/.ssh/id_personal";
  };

  mount-partition = {
    enable = false;
    partition_id = "";
  };
}
