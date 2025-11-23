{
  pkgs,
  settings,
  ...
}: {
  home = {
    username = settings.username;
    homeDirectory = "/home/${settings.username}";
    stateVersion = "24.11";

    file = {
      # Top Level Files symlinks
      # ".zshrc".source = ../../dotfiles/.zshrc;
      ".vimrc".source = ../../dotfiles/.vimrc;

      # Directories
      # ".config/kitty".source = ../../dotfiles/.config/kitty;
      # ".config/wezterm".source = ../../dotfiles/.config/wezterm;
      ".config/mpv".source = ../../dotfiles/.config/mpv;
      ".config/fastfetch".source = ../../dotfiles/.config/fastfetch;
      ".config/wlogout/icons".source = ../../dotfiles/.config/wlogout/icons;

      # Files
      # ".config/starship.toml".source = ../../dotfiles/.config/starship.toml;
      ".local/bin/cliphist-rofi-img".source =
        ../../dotfiles/.local/bin/cliphist-rofi-img;
      ".config/autostart/mega-sync.desktop".source = ../../dotfiles/.config/autostart/mega-sync.desktop;
    };

    sessionPath = ["$HOME/.local/bin" "$HOME/go/bin"];

    packages = [
      (import ../../scripts/rofi-launcher.nix {inherit pkgs;})
    ];
  };

  imports = [
    ../../config
  ];

  gtk = {
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.unstable.papirus-icon-theme;
    };
    gtk3.extraConfig = {gtk-application-prefer-dark-theme = 1;};
    gtk4.extraConfig = {gtk-application-prefer-dark-theme = 1;};
  };

  qt.enable = true;

  programs.home-manager.enable = true;
}
