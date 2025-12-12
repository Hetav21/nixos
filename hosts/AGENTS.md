# Hosts

## Profile Operations

### Enable Module in Profile

```nix
# Profiles wrap module enables in their config block:
config = mkIf config.profiles.system.<profile>.enable {
  system.category.enable = true;
  system.category.enableGui = true;
};
```

### Disable Module in Profile

Remove the enable statement from the profile's config block.

### Create Profile

```nix
# 1. Create hosts/_common/profiles/{system,home}/<name>.nix
{lib, config, ...}: with lib; {
  options.profiles.system.<name> = {
    enable = mkEnableOption "Description";
  };
  
  config = mkIf config.profiles.system.<name>.enable {
    # Enable modules here
  };
}
# 2. Import in profiles/{system,home}/default.nix
```

### Delete Profile

```
1. Remove all references to profile
2. Remove import from default.nix
3. Delete profile file
```

---

## Host Operations

### Add Host Override

```nix
# In hosts/<host>/configuration.nix or home.nix
system.category.setting = "host-specific-value";
```

### Remove Host Override

Delete the override from host config. The profile default will apply.

### Add New Host

```
1. Create hosts/<hostname>/configuration.nix and home.nix
2. Create config/<hostname>.nix with host settings
3. Add nixosConfigurations.<hostname> in flake.nix:

nixosConfigurations.<hostname> = nixpkgs.lib.nixosSystem {
  system = <settings>.system;
  specialArgs = { ... };
  modules = [./hosts/<hostname>/configuration.nix] ++ moduleLib.common;
};
```

### Configure Hardware

```
1. Create/edit config/hardware/<preset>.nix
2. Pass via specialArgs.hardware in flake.nix
```
