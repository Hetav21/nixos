# Code Style Guidelines

## Naming Conventions

- Use dots (not hyphens) in option paths: `system.category.feature`
- System modules: `system.<category>.*`
- Home modules: `home.<category>.*`
- Hardware drivers: `drivers.<vendor>.*`
- Profiles (module bundles): `profiles.<scope>.*`

A few pre-convention modules sit flat under `system.` with no category — when editing an existing module, match the file you're editing; use the hierarchy above for new modules.

## Module Pattern

All modules use the `extraLib.modules.mkModule` helper for consistent behavior and auto-generated enable options.

**Source of truth:** `lib/modules.nix`. The full API is exactly six attrs — `name`, `hasCli` (default `true`), `hasGui` (default `false`), `guiRequiresCli` (default `true`), `cliConfig`, `guiConfig` (each may be a function of module args or a plain attrset). There is no `imports`/`extraOptions` passthrough — if a module needs more than these six, write it as a plain module.

**Requirements:**

1. Destructure `extraLib` and other args (`lib`, `pkgs`, `config`) in the top-level function.
2. Pass `@ args` to the top-level function.
3. Call the result of `extraLib.modules.mkModule` with `args`.

```nix
{
  extraLib,
  lib,
  pkgs,
  config,
  ...
} @ args:
(extraLib.modules.mkModule {
  name = "system.<category>.<feature>";
  hasCli = true; # default true  -> generates <name>.enable
  hasGui = true; # default false -> generates <name>.enableGui

  # Configuration for CLI/Server (enabled by cfg.enable)
  cliConfig = _: {
    environment.systemPackages = [ pkgs.tool ];
  };

  # Configuration for GUI (enabled by cfg.enableGui)
  guiConfig = _: {
    programs.gui-tool.enable = true;
  };
}) args
```

## Best Practices

**DO:**

- Use profiles for common configurations
- Follow namespace hierarchy
- Create enable options for all modules
- Keep modules focused and single-purpose
- Use `lib.getExe` for package binaries

**DON'T:**

- Use hyphens in option paths (use dots)
- Mix system and home configurations
- Hardcode user-specific paths
- Create modules without enable options
