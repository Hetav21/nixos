# Core Home Manager Base
#
# Baseline Home Manager configuration applied to all user environments.
{
  inputs,
  settings,
  extraLib,
  ...
}: {
  # --- Imports ---
  imports = [
    ../modules/home
    ../profiles/home
    inputs.nix-index-database.homeModules.nix-index
    inputs.nixvim.homeModules.nixvim
  ];

  # --- Home Manager Base Configuration ---
  home = {
    username = settings.username;
    homeDirectory = "/home/${settings.username}";
    stateVersion = "25.11";

    # Common dotfiles present on all hosts
    file = {
      ".vimrc".source = extraLib.paths.dotfile ".vimrc";
      ".config/fastfetch".source = extraLib.paths.dotfile ".config/fastfetch";
    };

    # Common session paths
    sessionPath = ["$HOME/.local/bin" "$HOME/go/bin"];
  };

  # --- Home Manager Program Enablement ---
  programs.home-manager.enable = true;
}
