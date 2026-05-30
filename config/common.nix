{
  # Common settings shared across all hosts

  # Upgrade configuration
  inputs = {
    standard = [
      "nix-index-database"
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
  browser = "helium";
  terminal = "ghostty";

  # Git identities
  git = {
    personal = {
      name = "Hetav21";
      email = "shahhetav2106@gmail.com";
    };
    work = {
      name = "";
      email = "";
    };
  };

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

  # Host mode: "personal" (default), "work", or custom modes
  # Controls which dotfile variants are loaded (e.g., config.work.json)
  mode = "personal";

  # Nix build configuration (can be overridden per-host)
  nix = {
    maxJobs = 2;
    cores = 8;
  };

  # Application common configuration
  wallpaper_directory = "/etc/nixos/wallpapers";

  # AI tool configuration (models, providers)
  opencode = {
    model = "github-copilot/gpt-5-mini";
    smallModel = "github-copilot/gpt-5-mini";
  };

  ohMyOpencode = {
    preset = "github";
    models = {
      orchestrator = "github-copilot/gpt-5-mini";
      oracle = "github-copilot/gpt-5-mini";
      librarian = "github-copilot/gpt-5-mini";
      explorer = "github-copilot/gpt-5-mini";
      designer = "github-copilot/gpt-5-mini";
      fixer = "github-copilot/gpt-5-mini";
    };
  };
}
