{
  # Common settings shared across all hosts

  # Upgrade configuration
  inputs = {
    standard = [
      "nix-index-database"
      "claude-subagents"
      "claude-skills"
      "superpowers"
      "home-manager"
      "sops-nix"
      "stylix"
    ];
    latest = [
      "nixpkgs-unstable"
      "nixpkgs-master"
      "nixCats"
      "nur"
    ];
  };

  # User configuration
  username = "hetav";
  editor = "nvim";
  visual = "zeditor";
  browser = "zen";
  terminal = "ghostty";

  # System configuration (common)
  setup_dir = "/etc/nixos/";
  system = "x86_64-linux";
  locale = "en_US.UTF-8";
  extraLocale = "en_IN";
  timeZone = "Asia/Kolkata";
  keyboard = {
    layout = "us";
    variant = "";
  };
  consoleKeymap = "us";

  # Nix build configuration (can be overridden per-host)
  nix = {
    maxJobs = 2;
    cores = 8;
  };

  # Application common configuration
  wallpaper_directory = "/etc/nixos/wallpapers";
}
