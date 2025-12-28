# nixbook host-specific settings
# These are merged with common.nix using hostLib.mkHostSettings
{
  hostname = "nixbook";
  wallpaper = "China.jpeg";

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

  mount-partition = {
    enable = false;
    partition_id = "";
  };
}
