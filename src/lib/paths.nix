# Path & Resource Helpers
#
# Centralizes all repository resource paths (assets, dotfiles, wallpapers,
# scripts, secrets, templates) to eliminate fragile relative path traversals.
{lib}: rec {
  # Base directories (relative to flake root)
  root = ../..;

  # Top-level sections
  src = root + "/src";
  assets = root + "/assets";
  secrets = root + "/secrets";
  docs = root + "/docs";
  templates = root + "/templates";

  # Asset subdirectories
  wallpapers = assets + "/wallpapers";
  dotfiles = assets + "/dotfiles";
  scripts = assets + "/scripts";

  # Resolvers
  # e.g. paths.dotfile ".config/kitty/kitty.conf"
  dotfile = rel: dotfiles + "/${rel}";

  # e.g. paths.wallpaper "China.jpeg"
  wallpaper = name: wallpapers + "/${name}";

  # e.g. paths.script "patch.sh"
  script = rel: scripts + "/${rel}";

  # e.g. paths.secret "openai_api_key.yaml"
  secret = name: secrets + "/${name}";

  # e.g. paths.template "empty"
  template = name: templates + "/${name}";
}
