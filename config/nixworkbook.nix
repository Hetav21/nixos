# nixworkbook host-specific settings
# These are merged with common.nix using hostLib.mkHostSettings
{
  hostname = "nixworkbook";
  mode = "work";

  # Add wallpaper for stylix TUI/CLI theming (color scheme generation)
  wallpaper = "China.jpeg";

  # Build configuration for WSL (shared resources with Windows)
  nix = {
    maxJobs = 2;
    cores = 4;
  };

  # SSH key configuration
  ssh = {
    work.identityFile = "~/.ssh/id_work";
    personal.identityFile = "~/.ssh/id_personal";
  };

  # Inputs specific to WSL
  inputs = {
    standard = [
      "nixos-wsl"
    ];
  };

  # AI tool configuration for work mode
  opencode = {
    model = "openai/gpt-5.4-mini";
    smallModel = "openai/gpt-5.4-mini";
  };

  ohMyOpencode = {
    preset = "openai";
    models = {
      orchestrator = "openai/gpt-5.4";
      oracle = "openai/gpt-5.4";
      librarian = "openai/gpt-5.4-mini";
      explorer = "openai/gpt-5.4-mini";
      designer = "openai/gpt-5.4-mini";
      fixer = "openai/gpt-5.4-mini";
      observer = "openai/gpt-5.4";
    };
  };
}
