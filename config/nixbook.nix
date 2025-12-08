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
    local_dir = "Desktop/University";
    remote_dir = "Adani:University";
  };

  mount-partition = {
    enable = true;
    partition_id = "a96c2e2f-5a1a-4249-8a3c-283532bb14a9";
  };
}
