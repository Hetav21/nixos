# Infrastructure Operations

## Security Considerations

- **Never commit decrypted secrets**
- Use `sops-nix` for secret management (see `secrets/README.md`)
- Keep SSH keys and API tokens in `secrets/` only

## Change Namespace

```
1. Update option paths in module
2. Update all profile references
3. Update all host overrides
4. Test with nx flake check
```

## Update Flake Input

```bash
# Update all inputs
nx update

# Update specific input
nix flake update nixpkgs
```

## Add Custom Package

The overlay in `overlays/default.nix` already exposes everything from `pkgs/default.nix` as `pkgs.custom.<name>` — you don't edit the overlay itself.

```
1. Create pkgs/my-package/default.nix
2. Add it to pkgs/default.nix (callPackage) so it appears as pkgs.custom.my-package
```

See **[pkgs/AGENTS.md](../pkgs/AGENTS.md)** for details.

## Add/Modify Secret

```nix
# 1. Create encrypted file: sops secrets/my_secret.yaml
# 2. In secrets/default.nix, inside the sops block:
secrets.my_secret = {
  sopsFile = ./my_secret.yaml;

  mode = "0440";
  owner = config.users.users.${settings.username}.name;
  group = config.users.users.${settings.username}.group;
};
```
