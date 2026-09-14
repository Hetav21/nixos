# Project Context

Repository identity, component boundaries, runtime wiring, and security contracts for this NixOS configuration flake.

## Product & Ownership

- **System:** Multi-Host NixOS Flake configuration supporting desktop (Asus) and WSL environments with Home Manager, Stylix, and declarative agent toolchains.
- **Owner:** Hetav (`@Hetav21`)
- **Repository Remote:** `git@github.com:Hetav21/nixos.git`
- **Scope Boundary:** Manages operating system configuration, hardware profiles, user dotfiles, encrypted secrets, custom package definitions, and developer environments for all configured hosts.

## Repository Topography & Entry Points

**Source of truth:** [flake.nix](../flake.nix)

- `flake.nix` — Flake entry point declaring inputs, host outputs (`nixosConfigurations.<host>`), overlays, and system templates.
- `src/core/` — Core system initialization (`system.nix`) and library helper functions (`lib/`).
- `src/hosts/<hostname>/` — Per-host configuration and hardware definitions (e.g. `nixbook`, `nixwslbook`, `nixworkbook`).
- `src/modules/` — Modular configuration components using the `extraLib.modules.mkModule` pattern:
  - `src/modules/system/` — System-level NixOS modules (desktop, hardware, network, productivity, storage, virtualisation, etc.).
  - `src/modules/home/` — Home Manager user modules (browser, desktop, development, media, shell, system).
  - `src/modules/drivers/` — Hardware graphics and vendor driver modules (AMD, Intel, NVIDIA, ASUS).
- `src/pkgs/` — Custom packages and overlays; includes `src/pkgs/agent-sources` sub-flake.
- `secrets/` — SOPS-encrypted secret files managed via `sops-nix`.
- `assets/dotfiles/` — Raw dotfile assets managed and symlinked into user environment.

## Dependencies & Flake Inputs

**Source of truth:** [flake.nix](../flake.nix) and [flake.lock](../flake.lock)

- Core distribution: `nixpkgs`, `nixpkgs-unstable`, `nixpkgs-master`.
- System & Environment: `home-manager`, `stylix`, `sops-nix`, `nixos-wsl`, `lanzaboote`, `nix-flatpak`.
- Agent & Tooling: `inputs.llm-agents` (binary cached agent CLIs), `inputs.nix-skills` (declarative skills & resources), `vicinae-extensions`, `nixvim`.

## Commands & Verification

**Source of truth:** [docs/commands.md](commands.md)

- Rebuild & Test: `nh os test` (interactive local activation without adding bootloader entry).
- Rebuild & Permanent Switch: `nh os switch` (requires explicit user confirmation).
- Flake Evaluation / Check: `nix eval .#nixosConfigurations.<host>.config.system.build.toplevel --apply 'x: "ok"'` and `nix flake check`.
- Dry Run: `nix build .#nixosConfigurations.<host>.config.system.build.toplevel --dry-run`.

## Security & Authentication Boundaries

**Source of truth:** [docs/operations.md](operations.md) and [src/modules/system/secrets.nix](../src/modules/system/secrets.nix)

- **Secrets Storage:** Encrypted with SOPS (`.sops.yaml`) in `secrets/`. Decryption happens at runtime on target hosts via age keys (`~/.config/sops/age/keys.txt` or `/var/lib/sops-nix/key.txt`).
- **Human Authentication Invariant:** Authentication is strictly human-controlled. Agents must never inspect, read, copy, or print age keys or plaintext secret payloads. Whenever SSH authentication, GPG signing, GitHub push credentials, or token refresh is required, agents must stop and hand off to the human.

## Agent Toolchain Wiring

**Source of truth:** [docs/agent-environment.md](agent-environment.md) and [src/modules/home/development/agents.nix](../src/modules/home/development/agents.nix)

- AI agent tooling (OpenCode, Claude Code, Codex, Beads, Antigravity) is configured declaratively in `home.development.agents`.
- Declarative agent skills and commands are wired through `programs.agent-resources` using the `nix-skills` flake library.
