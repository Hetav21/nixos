# Module System Helpers
inputs: outputs: let
  inputsConfig = import ../config/inputs.nix {inherit inputs outputs;};
in rec {
  # --- Host Module Lists ---
  inherit (inputsConfig.modules) common desktop wsl;

  # --- Module Factory ---
  # Generates boilerplate options and conditional configs for CLI and GUI modules.
  # Supports both `mkModule args { ... }` and `(mkModule { ... }) args`.
  mkModule = a: b: let
    isSpec = x: builtins.isAttrs x && x ? name;
    spec =
      if isSpec a
      then a
      else b;
    givenArgs =
      if isSpec a
      then b
      else a;

    evaluateModule = {
      name,
      hasCli ? true,
      hasGui ? false,
      guiRequiresCli ? true,
      imports ? [],
      cliConfig ? (_: {}),
      guiConfig ? (_: {}),
    }: {
      lib,
      config,
      ...
    } @ args: let
      pathParts = lib.splitString "." name;
      cfg = lib.getAttrFromPath pathParts config;
      resolvedCli =
        if builtins.isFunction cliConfig
        then cliConfig args
        else cliConfig;
      resolvedGui =
        if builtins.isFunction guiConfig
        then guiConfig args
        else guiConfig;
    in {
      inherit imports;

      options = lib.setAttrByPath pathParts (
        lib.optionalAttrs hasCli {
          enable = lib.mkEnableOption "CLI/TUI tools for ${name}";
        }
        // lib.optionalAttrs hasGui {
          enableGui = lib.mkEnableOption "GUI tools for ${name}";
        }
      );

      config = lib.mkMerge [
        (lib.mkIf (hasCli && cfg.enable or false) resolvedCli)
        (lib.mkIf (hasGui && cfg.enableGui or false) (
          lib.mkMerge [
            (lib.optionalAttrs (hasCli && guiRequiresCli) (
              lib.setAttrByPath (pathParts ++ ["enable"]) true
            ))
            resolvedGui
          ]
        ))
      ];
    };
  in
    if givenArgs == null
    then evaluateModule spec
    else evaluateModule spec givenArgs;

  # --- Category Module Factory ---
  # Generates boilerplate options and default-propagation wiring for category default.nix files.
  mkCategoryModule = a: b: let
    isSpec = x: builtins.isAttrs x && x ? name;
    spec =
      if isSpec a
      then a
      else b;
    givenArgs =
      if isSpec a
      then b
      else a;

    evaluateCategory = {
      name,
      imports ? [],
      hasCli ? false,
      hasGui ? false,
      cliDescription ? "Enable all ${name} CLI components",
      guiDescription ? "Enable all ${name} GUI components",
      cliChildren ? [],
      guiChildren ? [],
      extraOptions ? {},
      extraConfig ? {},
    }: {
      lib,
      config,
      ...
    } @ args: let
      pathParts = lib.splitString "." name;
      catCfg = lib.getAttrFromPath pathParts config;
      resolvedExtraConfig =
        if builtins.isFunction extraConfig
        then extraConfig args
        else extraConfig;

      cliBindings =
        if hasCli
        then
          map (child:
            lib.setAttrByPath (pathParts ++ [child "enable"]) (lib.mkDefault (catCfg.enable or false))
          ) cliChildren
        else [];

      guiBindings =
        if hasGui
        then
          map (child:
            lib.setAttrByPath (pathParts ++ [child "enableGui"]) (lib.mkDefault (catCfg.enableGui or false))
          ) guiChildren
        else [];
    in {
      inherit imports;

      options =
        (lib.setAttrByPath pathParts (
          lib.optionalAttrs hasCli {
            enable = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = cliDescription;
            };
          }
          // lib.optionalAttrs hasGui {
            enableGui = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = guiDescription;
            };
          }
        ))
        // extraOptions;

      config = lib.mkMerge (cliBindings ++ guiBindings ++ [resolvedExtraConfig]);
    };
  in
    if givenArgs == null
    then evaluateCategory spec
    else evaluateCategory spec givenArgs;

  # --- Profile Module Factory ---
  # Generates boilerplate enable option and conditional config for profile modules (profiles.*.*).
  mkProfileModule = a: b: let
    isSpec = x: builtins.isAttrs x && x ? name;
    spec =
      if isSpec a
      then a
      else b;
    givenArgs =
      if isSpec a
      then b
      else a;

    evaluateProfile = {
      name,
      description ? "Enable ${name} profile",
      imports ? [],
      extraOptions ? {},
      profileConfig ? {},
    }: {
      lib,
      config,
      ...
    } @ args: let
      pathParts = lib.splitString "." name;
      isEnabled = lib.attrByPath (pathParts ++ ["enable"]) false config;
      resolvedConfig =
        if builtins.isFunction profileConfig
        then profileConfig args
        else profileConfig;
    in {
      inherit imports;

      options =
        (lib.setAttrByPath (pathParts ++ ["enable"]) (lib.mkEnableOption description))
        // extraOptions;

      config = lib.mkIf isEnabled resolvedConfig;
    };
  in
    if givenArgs == null
    then evaluateProfile spec
    else evaluateProfile spec givenArgs;
}
