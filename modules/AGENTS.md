# Modules

## Decision Trees

### Where Should This Configuration Go?

```
Is it user-specific (dotfiles, user apps)?
├─ YES → modules/home/
│   ├─ Terminal app? → modules/home/shell.nix
│   ├─ Desktop app? → modules/home/desktop/
│   └─ Browser? → modules/home/browser/
│
└─ NO → Is it hardware-related?
    ├─ YES → modules/drivers/ or modules/system/hardware/
    │
    └─ NO → modules/system/
        ├─ Desktop-related? → modules/system/desktop/
        ├─ System utility? → modules/system/misc/
        └─ Nix config? → modules/system/nix-*.nix
```

### Should I Create a New Module?

```
Does a module for this purpose already exist?
├─ YES → Add to existing module
│   └─ Is it getting too large (>200 lines)?
│       ├─ YES → Consider splitting into sub-modules
│       └─ NO → Add to existing
│
└─ NO → Create new module
    └─ Will other hosts use this?
        ├─ YES → Create as module with enable option
        └─ NO → Add directly to host configuration
```

---

## Module Operations

### Create Module

```
1. Create file in modules/system/<category>/ or modules/home/<category>/
2. Add imports to default.nix in that directory
3. Enable in relevant profile at hosts/_common/profiles/
```

### Delete Module

```
1. Remove enable statements from all profiles
2. Remove import from default.nix
3. Delete the module file
```

### Rename Module

```
1. Rename the file
2. Update import path in default.nix
3. Update all option references (grep for old name)
```

### Move Module

```
1. Move file to new location
2. Remove import from old default.nix
3. Add import to new default.nix
4. Update option namespace if needed
```

### Split Module

```
1. Create subdirectory with default.nix
2. Extract code into separate files
3. Import sub-modules in the new default.nix
4. Update parent default.nix to import the directory
```

### Merge Modules

```
1. Copy content from source module to target
2. Update option namespaces if needed
3. Remove source module import
4. Delete source module file
```

---

## Package & Service Operations

### Add Package

```nix
# System package
environment.systemPackages = with pkgs; [ new-package ];

# Home package
home.packages = with pkgs; [ new-package ];

# Unstable channel
pkgs.unstable.new-package
```

### Add/Modify Service

```nix
services.servicename = {
  enable = true;
  setting = "value";
};
```

### Add Option

```nix
options.system.category.newOption = mkOption {
  type = types.bool;
  default = false;
  description = "Description";
};
```

### Add Enable Flags

```nix
options.system.category = {
  enable = mkEnableOption "Enable CLI/TUI tools";
  enableGui = mkEnableOption "Enable GUI tools";
};
```

---

## Config Conversions

### Inline → Dotfile

```
1. Create file in dotfiles/.config/<app>/
2. Load content with builtins.readFile:
   builtins.readFile ../../dotfiles/.config/<app>/config.nu
3. Concatenate with Nix-interpolated code if needed
```

### Dotfile → Inline

```
1. Copy file content into module
2. Use programs.* options or inline text
3. Delete external file from dotfiles/
```

### Static → Templated

```nix
# Use Nix interpolation after loading
extraConfig = 
  builtins.readFile ../../dotfiles/.config/app/config.nu
  + ''
    # Add Nix-interpolated content
    path = "${lib.getExe pkgs.app}"
  '';
```

### programs.* → Manual

```
1. Disable programs.app.enable
2. Add package to home.packages
3. Load config via builtins.readFile or inline
```

### Manual → programs.*

```nix
programs.app = {
  enable = true;
  settings = { ... };
};
# Remove manual package and config
```

---

## Load Dotfile

```nix
# Load file content (allows concatenation with Nix code)
extraConfig = builtins.readFile ../../dotfiles/.config/app/config.nu;

# For complex templating (like panel.nix)
configDir = ../../../dotfiles/.config/app;
processedConfig = pkgs.replaceVars (configDir + "/template.qml") {
  setting = "value";
};
```

