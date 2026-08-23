{
  # --- Host Identity ---
  hostname = "nixworkbook";
  mode = "work";
  wallpaper = "China.jpeg";

  # --- Input Upgrade Channels ---
  inputs = {
    standard = [
      "nixos-wsl"
    ];
  };

  # --- Nix Build Configuration ---
  nix = {
    maxJobs = 2;
    cores = 4;
  };

  # --- SSH Identities ---
  ssh = {
    work.identityFile = "~/.ssh/id_work";
    personal.identityFile = "~/.ssh/id_work";
  };
}
