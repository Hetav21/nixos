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
  mkHostSettings = common: overrides: lib.recursiveUpdate common overrides;
}
