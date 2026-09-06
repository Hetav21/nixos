# Infrastructure Operations

Thin index of cross-cutting workflows. Where a topic has an owning doc, the link is authoritative — this file doesn't restate details.

## Security Considerations

- **Never commit decrypted secrets**
- Use `sops-nix` for secret management
- Keep SSH keys and API tokens in `secrets/` only

## Change Namespace

```
1. Update option paths in module
2. Update all profile references
3. Update all host overrides
4. Test with nix flake check
```

## Update Flake Input

- Routine updates: `nix flake update` (or `nh os switch --update`) — see [docs/commands.md](commands.md).
- One-off single input: `nix flake update <input>`

## Add Custom Package

Package definitions live in `src/pkgs/`, exposed via overlay as `pkgs.custom.<name>`, and the agent-sources sub-flake workflow.

## Add/Modify Secret

sops workflow: secrets defined in `src/modules/system/secrets.nix`, encrypted payloads stored in `secrets/` with `.sops.yaml`.

## Binary Caches & CI Evaluation

Substituters in `flake.nix` (`nixConfig`) provide prebuilt binaries when building locally or switching configurations.

- **Evaluation vs Building**: Binary caches (like Cachix) are only queried when realizing (downloading/building) store paths.
- **Import From Derivation (IFD)**: The only scenario where Nix contacts a binary cache during evaluation is if a configuration uses IFD (where Nix must build a package mid-evaluation to read its output into another Nix expression).
  - This configuration does not use IFD.
  - Flake checks restrict/forbid IFD by default.
  - Therefore, CI evaluation requires no Cachix credentials or dedicated cache actions.
