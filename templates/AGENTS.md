# Claude-Ready Templates

All templates in this repository now come with built-in Claude Code support. They use the `mkProjectEnv` helper to automatically configure the `.claude/` directory with agents, skills, and configuration files.

## Quick Start

Initialize a new project using one of the available templates:

```bash
# Initialize a Python AI project
nix flake init -t github:Hetav21/nixos#ai-uv

# Initialize a Node.js Frontend project
nix flake init -t github:Hetav21/nixos#frontend-node

# Initialize a Go Backend project
nix flake init -t github:Hetav21/nixos#backend-go
```

## Available Templates

### Frontend
- **`frontend-bun`**: Bun environment with Playwright
- **`frontend-node`**: Node.js environment with Playwright

### Backend
- **`backend-bun`**: Bun backend environment
- **`backend-node`**: Node.js backend environment
- **`backend-go`**: Go backend environment

### AI & Data
- **`ai-pip`**: Python environment (pip)
- **`ai-uv`**: Python environment (uv)
- **`notebook`**: Jupyter Notebook environment

### Testing
- **`browser`**: Playwright testing environment

### Minimal
- `empty`: Empty environment

## How It Works

The magic happens in `mkProjectEnv` (provided by `dotfiles.lib.claude`). This helper:

1.  **Creates the `.claude/` directory** structure automatically when you enter the shell.
2.  **Installs Skills & Agents**: Fetches resources from the specified flake inputs and links them.
3.  **Ensures Write Access**: Sets correct permissions so Claude can write to `.claude/config.json`.

Example usage in `flake.nix`:

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    # 1. Add your skill/agent source here
    my-skills.url = "github:owner/repo";
    my-skills.flake = false;
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    devShells.x86_64-linux.default = mkProjectEnv {
      inherit pkgs inputs;
      
      # 2. Reference via inputs (Recommended)
      skills = [
        "${inputs.my-skills}/path/to/skill"
      ];
      
      agents = [
        "${inputs.my-skills}/path/to/agent.md"
      ];
    };
  };
}
```

## Best Practices

### Use Flake Inputs (Mandatory)

We strongly recommend defining all external resources as flake inputs.

**Why?**
- **Reproducibility**: The exact commit is locked in `flake.lock`.
- **Stability**: No broken URLs or changing content.
- **Speed**: Caches the repo in the Nix store.

**Do NOT use raw URLs** in the `agents` or `skills` lists. Always map them to an input first.

```nix
# ✅ GOOD
inputs.awesome-skills.url = "github:owner/repo";
# ...
skills = [ "${inputs.awesome-skills}/skill-name" ];

# ❌ BAD
skills = [ "https://github.com/owner/repo/tree/main/skill-name" ];
```

## Troubleshooting

### "Input 'foo' not found"

If you see an error like `error: input 'foo' not found`, it means you tried to use `inputs.foo` in your `mkProjectEnv` call, but you haven't defined `foo` in the `inputs` section of your `flake.nix`.

**Fix**: Add the missing input to the `inputs` block at the top of `flake.nix`.

### ".claude directory is read-only"

`mkProjectEnv` handles this automatically by copying files instead of symlinking strictly, and running `chmod` operations in the shell hook. If you still face issues, ensure you are using the latest version of the template/dotfiles library.
