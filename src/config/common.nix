{
  # --- User Defaults ---
  username = "hetav";
  editor = "nvim";
  visual = "zeditor";
  browser = "helium";
  terminal = "ghostty";

  # --- Git Identities ---
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

  # --- Locale & Keyboard ---
  setup_dir = "/etc/nixos";
  system = "x86_64-linux";
  locale = "en_US.UTF-8";
  extraLocale = "en_IN";
  timeZone = "Asia/Kolkata";
  keyboard = {
    layout = "us";
    variant = "";
  };
  consoleKeymap = "us";

  # --- Host Mode ---
  mode = "personal";

  # --- Nix Build Configuration ---
  nix = {
    maxJobs = 2;
    cores = 8;
  };

  # --- Assets ---
  wallpaper_directory = "/etc/nixos/assets/wallpapers";
}
