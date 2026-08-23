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
}
