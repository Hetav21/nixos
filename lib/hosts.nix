# Host configuration helpers
#
# Provides utilities for creating and merging host-specific settings
{lib}: {
  # mkHostSettings: Deep merge common settings with host-specific overrides
  #
  # Usage:
  #   mkHostSettings commonSettings {
  #     hostname = "nixbook";
  #     nix.maxJobs = 4;
  #   }
  #
  # This uses recursiveUpdate for deep merging nested attributes
  mkHostSettings = common: overrides: let
    merged = lib.recursiveUpdate common overrides;
    commonInputs = common.inputs or {};
    overridesInputs = overrides.inputs or {};

    mergeInputs = type: let
      commonList = commonInputs.${type} or [];
      hostList = overridesInputs.${type} or [];
      combined = commonList ++ hostList;
    in
      lib.concatStringsSep " " combined;
  in
    merged
    // {
      update-standard = mergeInputs "standard";
      update-latest = mergeInputs "latest";
    };
}
