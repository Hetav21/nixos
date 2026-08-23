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
4. Test with nx flake check
```

## Update Flake Input

- Routine updates: `nx update` — categories and semantics are owned by [docs/commands.md](commands.md).
- One-off single input: `nix flake update <input>`

## Add Custom Package

Package definitions live in `src/pkgs/`, exposed via overlay as `pkgs.custom.<name>`, and the agent-sources sub-flake workflow.

## Add/Modify Secret

sops workflow: secrets defined in `src/secrets/default.nix`, encrypted payloads stored in `secrets/` with `.sops.yaml`.
