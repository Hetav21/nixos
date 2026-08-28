# Code Style Guidelines

## Naming Conventions

- Use dots (not hyphens) in option paths: `system.category.feature`
- System modules: `system.<category>.*`
- Home modules: `home.<category>.*`
- Hardware drivers: `drivers.<vendor>.*`
- Profiles (module bundles): `profiles.<scope>.*`

A few pre-convention modules sit flat under `system.` with no category — when editing an existing module, match the file you're editing; use the hierarchy above for new modules.

## Module Pattern

All feature modules use `extraLib.modules.mkModule`, and category aggregates (`default.nix`) use `extraLib.modules.mkCategoryModule`.

**Source of truth:** `src/lib/modules.nix`.

### Feature Modules (`mkModule`)

The full API is exactly six attrs — `name`, `hasCli` (default `true`), `hasGui` (default `false`), `guiRequiresCli` (default `true`), `cliConfig`, `guiConfig` (each may be a function of module args or a plain attrset).

**Requirements:**

1. Destructure `extraLib` and required args in the top-level function.
2. Pass `@ args` to `extraLib.modules.mkModule args { ... }`.
3. Use section boundary comments (`# --- Section Name ---`) to demarcate logical blocks.

```nix
{
  extraLib,
  pkgs,
  ...
} @ args:
extraLib.modules.mkModule args {
  name = "system.<category>.<feature>";
  hasCli = true; # default true  -> generates <name>.enable
  hasGui = true; # default false -> generates <name>.enableGui

  # --- CLI / Server Configuration ---
  cliConfig = {
    environment.systemPackages = [ pkgs.tool ];
  };

  # --- GUI Configuration ---
  guiConfig = {
    programs.gui-tool.enable = true;
  };
}
```

### Category Modules (`mkCategoryModule`)

Category `default.nix` files aggregate submodules and automatically propagate category-level `enable`/`enableGui` options to children:

```nix
{
  extraLib,
  ...
} @ args:
extraLib.modules.mkCategoryModule args {
  name = "system.<category>";
  imports = [ ./submodule.nix ];
  hasCli = true;
  cliChildren = [ "submodule" ];
  hasGui = true;
  guiChildren = [ "submodule" ];
}
```

### Profile Modules (`mkProfileModule`)

Profile modules (`profiles.<scope>.<name>`) bundle multiple feature enablements and settings:

```nix
{
  extraLib,
  ...
} @ args:
extraLib.modules.mkProfileModule args {
  name = "profiles.<scope>.<name>";
  description = "<Scope> profile description";

  profileConfig = {
    # Feature enables and configuration
    system.<category>.<feature>.enable = true;
  };
}
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
