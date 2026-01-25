# Claude-Ready Templates

All templates in this repository now come with built-in Claude Code support. They use the `mkProjectEnv` helper to automatically configure the `.claude/` directory with agents, skills, and configuration files.

## Quick Start

Initialize a new project using one of the available templates:

```bash
# Initialize a Python project
nix flake init -t github:Hetav21/nixos#python

# Initialize a Node.js project
nix flake init -t github:Hetav21/nixos#node

# Initialize a Go project
nix flake init -t github:Hetav21/nixos#go
```

## Available Templates

- `bun`: Bun runtime environment
- `go`: Go development environment
- `jupyter`: Jupyter notebook environment with Python
- `nix`: Nix development environment
- `node`: Node.js development environment
- `playwright`: Playwright testing environment
- `python`: Python development environment (with venv)
- `shell`: Generic shell environment
- `uv`: Python environment using `uv` package manager

## How It Works

The magic happens in `mkProjectEnv` (provided by `dotfiles.lib.claude`). This helper:

1.  **Creates the `.claude/` directory** structure automatically when you enter the shell.
2.  **Installs Skills & Agents**: Fetches resources from the specified sources and links them.
3.  **Ensures Write Access**: Sets correct permissions so Claude can write to `.claude/config.json` and other files (often an issue with read-only Nix store paths).

Example usage in `flake.nix`:

```nix
mkProjectEnv {
  inherit pkgs inputs;
  
  # Optional: Add custom skills or agents
  agents = [ "https://..." ];
  skills = [ "https://..." ];
}
```

## Adding Skills & Agents

You can add skills and agents to your project environment in two ways.

### Method 1: Robust Inputs (Recommended)

This method ensures reproducibility and stability by locking dependencies in `flake.lock`.

1.  **Add the source to `inputs`** in your `flake.nix`:

    ```nix
    inputs = {
      # ... other inputs ...
      superpowers.url = "github:Hetav21/superpowers";
    };
    ```

2.  **Reference it in `mkProjectEnv`**:

    ```nix
    mkProjectEnv {
      inherit pkgs inputs;
      
      agents = [
        # Reference via inputs
        inputs.superpowers + "/agents/coder.md"
      ];
      
      skills = [
        inputs.superpowers + "/skills"
      ];
    }
    ```

### Method 2: Raw URLs (Quick)

For quick experiments, you can use raw URLs directly.

> **⚠️ Warning**: If you paste a URL, verify it is stable. If the content changes, the hash will change, and you may see hash mismatch errors or need to update the lockfile frequently.

```nix
mkProjectEnv {
  inherit pkgs inputs;
  
  agents = [
    "https://github.com/Hetav21/superpowers/blob/main/agents/coder.md"
  ];
}
```

## Troubleshooting

### "Input 'foo' not found"

If you see an error like `error: input 'foo' not found`, it means you tried to use `inputs.foo` in your `mkProjectEnv` call, but you haven't defined `foo` in the `inputs` section of your `flake.nix`.

**Fix**: Add the missing input to the `inputs` block at the top of `flake.nix`.

### ".claude directory is read-only"

`mkProjectEnv` handles this automatically by copying files instead of symlinking strictly, and running `chmod` operations in the shell hook. If you still face issues, ensure you are using the latest version of the template/dotfiles library.
