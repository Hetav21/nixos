# Code Style Guidelines

## Naming Conventions

- Use dots (not hyphens) in option paths: `system.category.feature`
- System modules: `system.<category>.*`
- Home modules: `home.<category>.*`
- Hardware drivers: `drivers.<vendor>.*`

## Module Pattern

All modules must use `extraLib.modules.mkModule` helper to ensure consistent behavior and auto-generated enable options.

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
  name = "system.category.feature";
  # Optional: set to false if module has no CLI/GUI component
  hasCli = true;
  hasGui = true;

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
