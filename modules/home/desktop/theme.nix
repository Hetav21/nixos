{
  extraLib,
  pkgs,
  config,
  ...
} @ args:
extraLib.modules.mkModule args {
  name = "home.desktop.theme";
  hasCli = false;
  hasGui = true;

  guiConfig = {
    # --- GTK Theming ---
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

    # --- Qt Theming ---
    qt.enable = true;
  };
}
