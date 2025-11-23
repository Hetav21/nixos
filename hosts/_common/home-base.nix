# Common home-manager base configuration shared across all hosts
{settings, ...}: {
  home = {
    username = settings.username;
    homeDirectory = "/home/${settings.username}";
    stateVersion = "24.11";

    # Common dotfiles present on all hosts
    file = {
      ".vimrc".source = ../../dotfiles/.vimrc;
      ".config/fastfetch".source = ../../dotfiles/.config/fastfetch;
    };

    # Common session paths
    sessionPath = ["$HOME/.local/bin" "$HOME/go/bin"];
  };

  # Import home modules
  imports = [
    ../../modules/home
  ];

  # Enable home-manager
  programs.home-manager.enable = true;
}
