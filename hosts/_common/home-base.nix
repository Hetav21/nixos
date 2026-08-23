{
  inputs,
  settings,
  ...
}: {
  # --- Imports ---
  imports = [
    ../../modules/home
    ./profiles/home
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
      ".vimrc".source = ../../dotfiles/.vimrc;
      ".config/fastfetch".source = ../../dotfiles/.config/fastfetch;
    };

    # Common session paths
    sessionPath = ["$HOME/.local/bin" "$HOME/go/bin"];
  };

  # --- Home Manager Program Enablement ---
  programs.home-manager.enable = true;
}
