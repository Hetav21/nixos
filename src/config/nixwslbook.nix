{
  # --- Host Identity ---
  hostname = "nixwslbook";
  wallpaper = "China.jpeg";

  # --- Nix Build Configuration ---
  nix = {
    maxJobs = 2;
    cores = 4;
  };

  # --- SSH Identities ---
  ssh = {
    work.identityFile = "~/.ssh/id_work";
    personal.identityFile = "~/.ssh/id_personal";
  };
}
