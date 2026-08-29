{
  extraLib,
  pkgs,
  pkgs-unstable,
  settings,
  ...
} @ args:
extraLib.modules.mkModule args {
  name = "system.nix.settings";
  hasGui = false;
  cliConfig = {
    # --- System Packages ---
    environment.systemPackages = [pkgs.nix-update];

    # --- NH (Nix Helper) ---
    programs.nh = {
      enable = true;
      package = pkgs-unstable.nh;
      flake = settings.setup_dir;
      clean = {
        enable = true;
        dates = "weekly";
        extraArgs = "--keep 5 --keep-since 3d --no-direnv";
      };
    };

    # --- Environment Variables ---
    environment.variables = {
      EDITOR = settings.editor;
      VISUAL = settings.visual;
    };

    # --- Nix Daemon Settings ---
    nix = {
      settings = {
        trusted-users = ["root" settings.username];
        auto-optimise-store = true;
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        stalled-download-timeout = 99999999;
        max-jobs = settings.nix.maxJobs;
        cores = settings.nix.cores;
      };
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
        persistent = true;
      };
      optimise = {
        automatic = true;
        dates = ["weekly"];
      };
    };
  };
}
