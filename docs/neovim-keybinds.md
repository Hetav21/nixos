# Neovim Keybindings Guide

Declarative Neovim configuration is managed via [Nixvim](https://github.com/nix-community/nixvim) in `modules/home/development/neovim.nix` (module `home.development.neovim`).

**Source of truth:** `modules/home/development/neovim.nix` — the single site configuring all options, plugins, language servers, formatters, and keybindings.

---

## Leader Keys

* **`<leader>`**: `Space`
* **`<localleader>`**: `\`

Pressing `<leader>` and pausing opens the **which-key** popup menu with interactive descriptions.

---

## 1. Buffers & Tabs

Managed by `bufferline.nvim` and `snacks.bufdelete`.

| Keybinding | Action | Plugin / Handler |
| :--- | :--- | :--- |
| `<S-h>` / `[b` | Switch to previous buffer tab | `bufferline.nvim` |
| `<S-l>` / `]b` | Switch to next buffer tab | `bufferline.nvim` |
| `[B` | Move current buffer left in tabline | `bufferline.nvim` |
| `]B` | Move current buffer right in tabline | `bufferline.nvim` |
| `<leader>bp` | Toggle pin status on current buffer | `bufferline.nvim` |
| `<leader>bP` | Close all unpinned buffers | `bufferline.nvim` |
| `<leader>br` | Close all buffers to the right | `bufferline.nvim` |
| `<leader>bl` | Close all buffers to the left | `bufferline.nvim` |
| `<leader>bd` | Safely delete current buffer (preserves window layout) | `snacks.bufdelete` |

---

## 2. File Finding, Search & Terminal

Managed by `snacks.nvim`.

| Keybinding | Action | Plugin / Handler |
| :--- | :--- | :--- |
| `<leader><space>` | Fuzzy search files in workspace | `snacks.picker` |
| `<leader>ff` | Fuzzy search files in workspace | `snacks.picker` |
| `<leader>/` | Live grep workspace search | `snacks.picker` |
| `<leader>fb` | Fuzzy search and switch open buffers | `snacks.picker` |
| `<leader>e` | Toggle file tree explorer sidebar | `snacks.explorer` |
| `<C-\>` | Toggle floating / split terminal (Normal & Terminal modes) | `snacks.terminal` |

---

## 3. Git & Diffs

Managed by `diffview.nvim` and `gitsigns.nvim`.

| Keybinding | Action | Plugin / Handler |
| :--- | :--- | :--- |
| `<leader>gd` | Open full side-by-side git diff view | `diffview.nvim` |
| `<leader>gh` | View git commit history for current file | `diffview.nvim` |
| `<leader>gH` | View git commit history for current branch | `diffview.nvim` |
| `]c` | Jump to next git change hunk | `gitsigns.nvim` |
| `[c` | Jump to previous git change hunk | `gitsigns.nvim` |
| `<leader>hs` | Stage git hunk under cursor | `gitsigns.nvim` |
| `<leader>hr` | Reset git hunk under cursor | `gitsigns.nvim` |
| `<leader>hp` | Preview git hunk inline | `gitsigns.nvim` |
| `<leader>hb` | Show git blame for current line | `gitsigns.nvim` |

---

## 4. LSP & Code Intelligence

Managed by `nvim-lspconfig` and `inc-rename.nvim`.

| Keybinding | Action | Plugin / Handler |
| :--- | :--- | :--- |
| `gd` | Go to symbol definition | `plugins.lsp` (`vim.lsp.buf.definition`) |
| `gD` | Go to symbol declaration | `plugins.lsp` (`vim.lsp.buf.declaration`) |
| `gi` | Go to implementation | `plugins.lsp` (`vim.lsp.buf.implementation`) |
| `gr` | List all references | `plugins.lsp` (`vim.lsp.buf.references`) |
| `gy` | Go to type definition | `plugins.lsp` (`vim.lsp.buf.type_definition`) |
| `K` | Display hover documentation / signature | `plugins.lsp` (`vim.lsp.buf.hover`) |
| `<leader>ca` | Open LSP code actions menu | `plugins.lsp` (`vim.lsp.buf.code_action`) |
| `<leader>rn` | Incremental LSP symbol rename with live preview | `inc-rename.nvim` |
| `[d` | Jump to previous LSP diagnostic in file | `plugins.lsp` (`vim.diagnostic.goto_prev`) |
| `]d` | Jump to next LSP diagnostic in file | `plugins.lsp` (`vim.diagnostic.goto_next`) |
| `<leader>cd` | Open floating diagnostic details for current line | `plugins.lsp` (`vim.diagnostic.open_float`) |

---

## 5. Diagnostics & Workspace Issues

Managed by `trouble.nvim` and `todo-comments.nvim`.

| Keybinding | Action | Plugin / Handler |
| :--- | :--- | :--- |
| `<leader>xx` | Toggle workspace diagnostics panel | `trouble.nvim` |
| `<leader>xX` | Toggle current buffer diagnostics panel | `trouble.nvim` |
| `<leader>cs` | Toggle code symbols outline panel | `trouble.nvim` |
| `<leader>xL` | Toggle location list | `trouble.nvim` |
| `<leader>xQ` | Toggle quickfix list | `trouble.nvim` |
| `]t` | Jump to next TODO comment in buffer | `todo-comments.nvim` |
| `[t` | Jump to previous TODO comment in buffer | `todo-comments.nvim` |

---

## 6. Editing, Surround & Yank History

Managed by `mini.surround` and `yanky.nvim`.

| Keybinding | Action | Plugin / Handler |
| :--- | :--- | :--- |
| `sa<motion><char>` | Add surrounding characters (e.g. `saiw"` surrounds word with `"`) | `mini.surround` |
| `sd<char>` | Delete surrounding characters (e.g. `sd"` removes `"`) | `mini.surround` |
| `sr<old><new>` | Replace surrounding characters (e.g. `sr"'` replaces `"` with `'`) | `mini.surround` |
| `[y` | Cycle backward through yank history ring | `yanky.nvim` |
| `]y` | Cycle forward through yank history ring | `yanky.nvim` |

---

## 7. Autocompletion

Managed by `blink.cmp`.

| Keybinding | Action | Plugin / Handler |
| :--- | :--- | :--- |
| `<Tab>` | Accept completion candidate / jump forward in snippet | `blink.cmp` |
| `<S-Tab>` | Jump backward in snippet | `blink.cmp` |
| `<CR>` (Enter) | Confirm / accept selected completion candidate | `blink.cmp` |
| `<C-Space>` | Open completion popup / toggle documentation preview | `blink.cmp` |
| `<C-j>` / `<C-n>` | Select next completion item | `blink.cmp` |
| `<C-k>` / `<C-p>` | Select previous completion item | `blink.cmp` |
| `<C-d>` / `<C-u>` | Scroll documentation preview down / up | `blink.cmp` |

---

## 8. Undo Tree & Session Recovery

Managed by `undotree` and `persistence.nvim`.

| Keybinding | Action | Plugin / Handler |
| :--- | :--- | :--- |
| `<leader>uu` | Toggle branching undo history tree sidebar | `undotree` |
| `<leader>qs` | Restore session for the current workspace directory | `persistence.nvim` |
| `<leader>ql` | Restore last active session | `persistence.nvim` |
| `<leader>qd` | Do not save session on editor exit | `persistence.nvim` |

---

## 9. Formatters (Auto Format on Save)

Managed by `conform-nvim`. Automatically formats on `:w`:

* **Nix**: `alejandra`
* **Python**: `ruff_format`, `black`
* **Go**: `gofmt`, `goimports`
* **JavaScript / TypeScript / JSON / YAML / Markdown**: `prettier`
* **Shell**: `shfmt`
