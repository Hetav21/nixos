# Infrastructure Operations

Thin index of cross-cutting workflows. Where a topic has an owning doc, the link is authoritative — this file doesn't restate details.

## Security Considerations

- **Never commit decrypted secrets**
- Use `sops-nix` for secret management (see [secrets/README.md](../secrets/README.md))
- Keep SSH keys and API tokens in `secrets/` only

## Change Namespace

```
1. Update option paths in module
2. Update all profile references
3. Update all host overrides
4. Test with nx flake check
```

## Update Flake Input

- Routine updates: `nx update` — categories and semantics are owned by [docs/nx-commands.md](nx-commands.md).
- One-off single input: `nix flake update <input>`

## Add Custom Package

Owned by **[pkgs/AGENTS.md](../pkgs/AGENTS.md)** — package definition, overlay exposure as `pkgs.custom.<name>`, and the agent-sources sub-flake workflow.

## Add/Modify Secret

Owned by **[secrets/README.md](../secrets/README.md)** — sops workflow, the secret entry shape in `secrets/default.nix`, and key management.
