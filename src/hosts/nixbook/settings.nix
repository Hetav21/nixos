{
  # --- Host Identity ---
  hostname = "nixbook";
  wallpaper = "China.jpeg";

  # --- Nix Build Configuration ---
  nix = {
    maxJobs = 4;
    cores = 8;
  };

  # --- SSH Identities ---
  ssh = {
    work.identityFile = "";
    personal.identityFile = "~/.ssh/id_personal";
  };

  # --- Storage & Mounts ---
  mountPartition = {
    partitionId = "";
  };

  rclone = {
    enable = false;
    local_dir = "";
    remote_dir = "";
  };
}
