{
  mkModule,
  lib,
  pkgs,
  pkgs-unstable,
  config,
  ...
} @ args:
(mkModule {
  name = "home.desktop.panel";
  hasCli = false;
  hasGui = true;
  guiConfig = _: let
    # Stylix colors (base16 scheme)
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

    # Font and theme
    fontFamily = config.stylix.fonts.monospace.name;
    iconThemeName = config.gtk.iconTheme.name or "Papirus-Dark";

    # Process QML files with variable substitution
    processQml = file:
      pkgs.replaceVars file {
        iconTheme = iconThemeName;
        inherit fontFamily;
        baseColor = colors.base;
        textColor = colors.text;
        inherit (colors) love rose gold iris pine overlay surface;
      };

    qmlDir = ../../../dotfiles/.config/quickshell;

    panelConfigDir = pkgs.runCommand "quickshell-panel-config" {} ''
      mkdir -p $out
      cp ${processQml (qmlDir + "/shell.qml")} $out/shell.qml
      cp ${qmlDir}/RoundedModuleBackground.qml $out/RoundedModuleBackground.qml
      cp ${qmlDir}/StyledToolTip.qml $out/StyledToolTip.qml
      cp ${qmlDir}/IconValueDisplay.qml $out/IconValueDisplay.qml
    '';
  in {
    assertions = [
      {
        assertion = config.stylix.enable or false;
        message = "home.desktop.panel requires stylix to be enabled for theming";
      }
    ];

    programs.quickshell = {
      enable = true;
      package = pkgs-unstable.quickshell;
      systemd = {
        enable = true;
        target = "hyprland-session.target";
      };
      activeConfig = "panel";
      configs.panel = panelConfigDir;
    };
  };
})
args
