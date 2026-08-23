# Host Settings Helpers
{lib}: {
  # Merges common settings with host overrides and aggregates input upgrade groups
  mkHostSettings = common: overrides: let
    merged = lib.recursiveUpdate common overrides;
    commonInputs = common.inputs or {};
    overridesInputs = overrides.inputs or {};

    mergeInputs = type:
      lib.concatStringsSep " " (
        (commonInputs.${type} or []) ++ (overridesInputs.${type} or [])
      );
  in
    merged
    // {
      update-standard = mergeInputs "standard";
      update-latest = mergeInputs "latest";
    };
}
