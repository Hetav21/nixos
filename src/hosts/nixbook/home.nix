{
  extraLib,
  ...
}: {
  # --- Profile & State Version ---
  profiles.home.desktop.enable = true;

  # --- Host-Specific Dotfiles ---
  home.file = {
    ".config/wlogout/icons".source = extraLib.paths.dotfile ".config/wlogout/icons";
    ".config/autostart/mega-sync.desktop".source = extraLib.paths.dotfile ".config/autostart/mega-sync.desktop";
  };
}
