# Host Settings Helpers
{lib}: {
  # Merges common settings with host overrides
  mkHostSettings = common: overrides: lib.recursiveUpdate common overrides;
}
