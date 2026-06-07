{
  extraLib,
  lib,
  pkgs,
  config,
  ...
} @ args:
(extraLib.modules.mkModule {
  name = "home.desktop.theme";
  hasCli = false;
  hasGui = true;
  guiConfig = _: {
    # GTK theming configuration (common for all desktop hosts)
    gtk = {
      enable = true;
      gtk3.extraConfig = {gtk-application-prefer-dark-theme = 1;};
      gtk4.extraConfig = {gtk-application-prefer-dark-theme = 1;};
      iconTheme = {
        name = let
          polarity = config.stylix.polarity or "dark";
          suffix =
            if polarity == "dark"
            then "Dark"
            else "Light";
        in "Papirus-${suffix}";
        package = pkgs.papirus-icon-theme;
      };
    };

    # Qt configuration (common for all desktop hosts)
    qt.enable = true;
  };
})
args
