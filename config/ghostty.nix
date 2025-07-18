{
  lib,
  pkgs,
  ...
}: let
  ghostty = pkgs.ghostty;

  ghosttyTheme = pkgs.writeTextFile {
    name = "ghostty-theme-Dracula";
    text = builtins.readFile "${ghostty}/share/ghostty/themes/Dracula";
  };
in {
  config = {
    home = {
      packages = [ghostty];
      sessionVariables = {
        GHOSTTY_RESOURCES_DIR = "${ghostty}/share";
      };
    };

    xdg.configFile."ghostty/config".text =
      lib.generators.toKeyValue
      {
        mkKeyValue = lib.generators.mkKeyValueDefault {} " = ";
        listsAsDuplicateKeys = true;
      }
      {
        background-opacity = 0.7;
        confirm-close-surface = false;
        copy-on-select = true;
        font-family = "JetBrainsMono Nerd Font";
        font-size = 12;
        font-style = "Regular";
        minimum-contrast = 1.1;
        theme = "${ghosttyTheme}";
        window-decoration = false;
        window-padding-x = 16;
        window-padding-y = 16;
      };
  };
}
