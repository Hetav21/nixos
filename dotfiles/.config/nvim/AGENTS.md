# Neovim Configuration (LazyVim)

## Build & Test
- **Lint/Format**: Use `stylua` for formatting (indent: 2 spaces).
- **Verify**: Run `nvim --headless "+Lazy! sync" +qa` to check plugin startup.
- **Reload**: Use `:so %` to source current file or restart Neovim to apply changes.

## Code Style & Conventions
- **Framework**: Strictly follow [LazyVim](https://www.lazyvim.org/) conventions.
  - Use `opts` table for plugin configuration whenever possible.
  - Avoid `config` function unless complex logic is required.
- **Nix Integration**: 
  - Do not assume external binaries (node, git) are standard; use `vim.env.*` or resolved paths if needed.
  - Nix handles the package installation; Lua handles the setup.
- **Formatting**: 2-space indentation, double quotes, trailing commas in tables.
- **Imports**: Modularize code in `lua/plugins/` by category (e.g., `editor.lua`, `coding.lua`).
- **Safety**: Check `vim.uv.fs_stat` before accessing files. Use `pcall` for risky requires.
