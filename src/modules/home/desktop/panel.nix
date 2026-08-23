{
  extraLib,
  pkgs,
  config,
  ...
} @ args:
extraLib.modules.mkModule args {
  name = "home.desktop.panel";
  hasCli = false;
  hasGui = true;

  guiConfig = let
    # --- Theme & Colors ---
    colors = {
      base = "#${config.stylix.base16Scheme.base00}";
      text = "#${config.stylix.base16Scheme.base05}";
      love = "#${config.stylix.base16Scheme.base08}";
      rose = "#${config.stylix.base16Scheme.base0A}";
      gold = "#${config.stylix.base16Scheme.base09}";
      iris = "#${config.stylix.base16Scheme.base0D}";
      pine = "#${config.stylix.base16Scheme.base0B}";
      overlay = "#${config.stylix.base16Scheme.base02}";
      surface = "#${config.stylix.base16Scheme.base01}";
    };

    fontFamily = config.stylix.fonts.monospace.name;
    iconThemeName = config.gtk.iconTheme.name or "Papirus-Dark";

    # --- QML Template Processing ---
    processQml = file:
      pkgs.replaceVars file {
        iconTheme = iconThemeName;
        inherit fontFamily;
        baseColor = colors.base;
        textColor = colors.text;
        inherit
          (colors)
          love
          rose
          gold
          iris
          pine
          overlay
          surface
          ;
      };

    qmlDir = extraLib.paths.dotfile ".config/quickshell";

    panelConfigDir = pkgs.runCommand "quickshell-panel-config" {} ''
      mkdir -p $out
      cp ${processQml (qmlDir + "/shell.qml")} $out/shell.qml
      cp ${qmlDir}/RoundedModuleBackground.qml $out/RoundedModuleBackground.qml
      cp ${qmlDir}/StyledToolTip.qml $out/StyledToolTip.qml
      cp ${qmlDir}/IconValueDisplay.qml $out/IconValueDisplay.qml
    '';
  in {
    # --- Assertions ---
    assertions = [
      {
        assertion = config.stylix.enable or false;
        message = "home.desktop.panel requires stylix to be enabled for theming";
      }
    ];

    # --- Quickshell Configuration ---
    programs.quickshell = {
      enable = true;
      package = pkgs.quickshell;
      systemd = {
        enable = true;
        target = "hyprland-session.target";
      };
      activeConfig = "panel";
      configs.panel = panelConfigDir;
    };
  };
}
