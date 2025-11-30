# Agent Navigation Guide

This document is a fast-start reference for agents working in this NixOS repository. It complements `README.md` (high-level overview) and `NAMING_CONVENTIONS.md` (authoritative structure rules). Keep those files open alongside this guide.

---

## 1. Mission & Layout

- **Primary goal:** maintain a modular, multi-host NixOS configuration with Home Manager integration, supporting desktop (`nixbook`) and WSL (`nixwslbook`) targets.
- **Entry points:**
  - `flake.nix` – inputs, overlays, host definitions.
  - `hosts/*/configuration.nix` – per-host system config.
  - `hosts/*/home.nix` – per-host Home Manager config.
  - `hosts/_common/` – shared system/home base, profiles, user definition.
  - `modules/system/*` – NixOS modules (namespaces `system.*`).
  - `modules/home/*` – Home Manager modules (namespaces `home.*`).
  - `.agent/` – agent-facing docs (this file).

Refer to `README.md#Repository-Structure` for the full tree and directory descriptions.

---

## 2. Core Concepts Recap

1. **Two-tier enable pattern** – most modules expose `enable` (CLI/TUI) and `enableGui` (GUI). Enabling GUI often forces `enable = true`.
2. **Namespaces** – option paths follow `system.*`, `home.*`, `drivers.*`, `profiles.*`. Full mapping lives in `NAMING_CONVENTIONS.md#Namespace-Hierarchy`.
3. **Profiles** – bundles under `hosts/_common/profiles/{system,home}` toggle curated sets of modules. Use these for host presets before tweaking individual modules.
4. **Settings vs hardware** – host metadata lives under `config/*.nix` (imported into `flake.nix`), while hardware presets live in `hardware/*.nix`.

---

## 3. Navigation Workflows

| Task | Key Files | Notes |
| --- | --- | --- |
| Add/modify system module | `modules/system/<category>.nix`, `modules/system/default.nix` | Follow option naming rules; ensure module imported. |
| Add/modify home module | `modules/home/<category>.nix`, `modules/home/default.nix` | Keep CLI/GUI split; document in README/NAMING if new namespace. |
| Change packages for a host | `hosts/<host>/configuration.nix` (system) or `home.nix` (home) | Prefer modules over host-local packages unless host-specific. |
| Adjust shared behavior | `hosts/_common/default.nix`, `hosts/_common/home-base.nix`, `hosts/_common/profiles/*` | Profiles auto-enable module sets—update both CLI & GUI flags. |
| Update inputs/overlays | `flake.nix`, `overlays/`, `pkgs/` | Keep `commonSettings` consistent; verify overlays used. |
| Modify secrets | `secrets/` (via sops) | Check `README.md#Secrets-Management`. Never commit decrypted data. |

When unsure where a feature comes from, search for its namespace (e.g., `system.media`), or use `rg "<option name>" -n`.

---

## 4. Search & Inspection Tips

- **ripgrep (`rg`)** – best for locating option declarations (`mkIf cfg.enable`). Combine with `--glob '*.nix'`.
- **`codebase_search` (semantic)** – use when you need conceptual matches (e.g., "where are profiles defined").
- **`list_dir` + `read_file`** – prefer these tools over shell equivalents per environment rules.
- **Tracing options:** start from host config → `profiles.*` → module file. Option names map 1:1 with namespace structure documented in `NAMING_CONVENTIONS.md`.

---

## 5. When to Update README & NAMING_CONVENTIONS

Keep these docs aligned with the codebase:

- **Update `README.md` when:**
  - Repository structure changes (new directories, modules, or major files).
  - Features/installation steps, profiles, or workflows change.
  - New user-facing capabilities or requirements are introduced.
  - Examples in README would become inaccurate after your change.

- **Update `NAMING_CONVENTIONS.md` when:**
  - You introduce new namespaces or move configuration categories.
  - Module organization, profiles, or enable-pattern rules change.
  - Decision trees or best practices become outdated.
  - You add recurring tasks that need guidance for future contributors.

If in doubt, mention your change in both docs and reference the relevant sections from this guide.

---

## 6. Implementation Checklist (Common Tasks)

1. **Add a new home module**
   - Copy pattern from `modules/home/<existing>.nix`.
   - Export options under `home.<namespace>.*`.
   - Import module via `modules/home/default.nix`.
   - Update README + NAMING if this introduces a new category.

2. **Modify a profile**
   - Edit `hosts/_common/profiles/{system,home}/<profile>.nix`.
   - Ensure both CLI (`enable`) and GUI (`enableGui`) flags reflect desired behavior.
   - Add/update quick notes in README (profile descriptions).

3. **Add host-specific tweaks**
   - Update `hosts/<host>/configuration.nix` or `home.nix`.
   - Keep host overrides minimal; push reusable logic into modules/profiles.

4. **Add packages**
   - System-wide: update relevant `modules/system/...` file and `environment.systemPackages`.
   - User-only: update `home.packages` inside the appropriate home module.

5. **Add a new system module**
   - Copy pattern from `modules/system/<existing>.nix`.
   - Export options under `system.<namespace>.*`.
   - Import module via `modules/system/default.nix`.
   - Add to relevant profile in `hosts/_common/profiles/system/<profile>.nix`.
   - Update NAMING_CONVENTIONS.md with new namespace and module details.

---

## 7. Quick Reference

- **Common directories**
  - `hosts/` – per-host configs
  - `modules/system/` – NixOS modules
  - `modules/home/` – Home Manager modules
  - `hosts/_common/` – shared logic & profiles
  - `config/`, `hardware/` – host metadata imports

- **Enable switches**
  - `system.<module>.enable`, `.enableGui`
  - `home.<module>.enable`, `.enableGui`
  - Profiles: `profiles.system.*.enable`, `profiles.home.*.enable`

- **Useful commands**
  - `nix flake update` – refresh inputs
  - `sudo nixos-rebuild switch --flake .#<host>` – apply changes
  - `rg "home\\.development" modules -n` – find option implementations

- **Doc touchpoints**
  - `README.md` – user-facing features/workflows
  - `NAMING_CONVENTIONS.md` – structure, naming, decision trees
  - `.agent/guide.md` – this agent-focused roadmap

---

## 8. Final Notes

- Always prefer non-destructive edits (`apply_patch`, module-level changes).
- Verify new modules with `nix flake check` when possible.
- After major documentation or module changes, revisit this guide and ensure references remain accurate.

Happy hacking!

