# Neovim Keybindings Guide

Declarative Neovim configuration is managed via [Nixvim](https://github.com/nix-community/nixvim) in `modules/home/development/neovim.nix` (module `home.development.neovim`).

**Source of truth:** `modules/home/development/neovim.nix` — the single site configuring all options, plugins, language servers, formatters, and keybindings.

---

## Leader Keys

* **`<leader>`**: `Space`
* **`<localleader>`**: `\`

Pressing `<leader>` opens the **which-key** popup menu with categorized groups (AI / Sidekick, Buffer, Code, Find, Git, Session, Diagnostics/Trouble).

---

## 1. Navigation & Windows

Direct split navigation across windows without `<C-w>` prefix overhead.

| Keybinding | Mode | Action | Plugin / Handler |
| :--- | :---: | :--- | :--- |
| `<C-h>` | Normal | Move focus to left window split | Built-in (`<C-w>h`) |
| `<C-j>` | Normal | Move focus to lower window split | Built-in (`<C-w>j`) |
| `<C-k>` | Normal | Move focus to upper window split | Built-in (`<C-w>k`) |
| `<C-l>` | Normal | Move focus to right window split | Built-in (`<C-w>l`) |

---

## 2. Text Manipulation & Visual Mode Ergonomics

| Keybinding | Mode | Action | Plugin / Handler |
| :--- | :---: | :--- | :--- |
| `J` | Visual | Move selected block down 1 line (auto-reindents) | Built-in (`:m '>+1`) |
| `K` | Visual | Move selected block up 1 line (auto-reindents) | Built-in (`:m '<-2`) |
| `<` | Visual | Indent selection left (preserves visual selection) | Built-in (`<gv`) |
| `>` | Visual | Indent selection right (preserves visual selection) | Built-in (`>gv`) |
| `<Esc>` | Normal | Clear active search highlights (`hlsearch`) | Built-in (`noh`) |
| `<C-s>` | Normal, Insert, Visual | Save current file | Built-in (`:w`) |

---

## 3. Buffers & Tabs

Managed by `bufferline.nvim` and `snacks.bufdelete`.

| Keybinding | Action | Plugin / Handler |
| :--- | :--- | :--- |
| `<S-h>` / `[b` | Switch to previous buffer tab | `bufferline.nvim` |
| `<S-l>` / `]b` | Switch to next buffer tab | `bufferline.nvim` |
| `[B` | Move current buffer left in tabline | `bufferline.nvim` |
| `]B` | Move current buffer right in tabline | `bufferline.nvim` |
| `<leader>bp` | Toggle pin status on current buffer | `bufferline.nvim` |
| `<leader>bP` | Close all unpinned buffers | `bufferline.nvim` |
| `<leader>bo` | Close all other buffers (preserves layout) | `snacks.bufdelete` |
| `<leader>br` | Close all buffers to the right | `bufferline.nvim` |
| `<leader>bl` | Close all buffers to the left | `bufferline.nvim` |
| `<leader>bd` | Open startup dashboard | `snacks.dashboard` |
| `<leader>bs` | Toggle persistent scratchpad buffer | `snacks.scratch` |

---

## 4. Find, Pickers & Terminal

Managed by `snacks.nvim`.

| Keybinding | Action | Plugin / Handler |
| :--- | :--- | :--- |
| `<leader><space>` / `<leader>ff` | Fuzzy search files in workspace | `snacks.picker` |
| `<leader>fr` | Fuzzy search recent / old files | `snacks.picker` |
| `<leader>/` / `<leader>fg` | Live grep workspace search | `snacks.picker` |
| `<leader>fb` | Fuzzy search and switch open buffers | `snacks.picker` |
| `<leader>fw` | Search word under cursor across workspace | `snacks.picker` |
| `<leader>fl` | Search lines in current buffer | `snacks.picker` |
| `<leader>fk` | Interactive keymaps picker | `snacks.picker` |
| `<leader>fh` | Search Vim help documentation | `snacks.picker` |
| `<leader>fq` | Search quickfix list items | `snacks.picker` |
| `<leader>f.` | Resume previous picker query | `snacks.picker` |
| `<leader>ft` | Search TODO / FIX / NOTE comments | `snacks.picker` |
| `<leader>fp` | Interactive yank history picker | `snacks.picker` / `yanky.nvim` |
| `<leader>fR` | Interactive Vim registers picker | `snacks.picker` |
| `<leader>fm` | Jump to marks across buffers | `snacks.picker` |
| `<leader>fc` | Search and execute command history | `snacks.picker` |
| `<leader>fn` | Show notification popup history | `snacks.notifier` |
| `<leader>e` | Toggle file tree explorer sidebar | `snacks.explorer` |
| `<C-\>` | Toggle floating / split terminal (Normal & Terminal) | `snacks.terminal` |

---

## 5. Git & Diffs

Managed by `diffview.nvim`, `gitsigns.nvim`, and `snacks.picker`.

| Keybinding | Mode | Action | Plugin / Handler |
| :--- | :---: | :--- | :--- |
| `<leader>gd` | Normal | Open full side-by-side git diff view | `diffview.nvim` |
| `<leader>gf` | Normal | View git commit history for current file | `diffview.nvim` |
| `<leader>gH` | Normal | View git commit history for current branch | `diffview.nvim` |
| `<leader>gs` | Normal | Interactive git status picker | `snacks.picker` |
| `<leader>gl` | Normal | Interactive git commit log picker | `snacks.picker` |
| `<leader>gb` | Normal | Show git blame for current line | `gitsigns.nvim` |
| `<leader>gp` / `<leader>ghp` | Normal | Preview git hunk inline | `gitsigns.nvim` |
| `]c` / `[c` | Normal | Jump to next / previous git change hunk | `gitsigns.nvim` |
| `<leader>ghs` | Normal, Visual | Stage git hunk (or visual selection) | `gitsigns.nvim` |
| `<leader>ghr` | Normal, Visual | Reset git hunk (or visual selection) | `gitsigns.nvim` |
| `<leader>ghu` | Normal | Undo last staged hunk | `gitsigns.nvim` |

---

## 6. LSP & Code Intelligence

Managed by `nvim-lspconfig`, `inc-rename.nvim`, and `conform-nvim`.

| Keybinding | Mode | Action | Plugin / Handler |
| :--- | :---: | :--- | :--- |
| `gd` | Normal | Go to symbol definition | `plugins.lsp` (`vim.lsp.buf.definition`) |
| `gD` | Normal | Go to symbol declaration | `plugins.lsp` (`vim.lsp.buf.declaration`) |
| `gi` | Normal | Go to implementation | `plugins.lsp` (`vim.lsp.buf.implementation`) |
| `gr` | Normal | List all references | `plugins.lsp` (`vim.lsp.buf.references`) |
| `gy` | Normal | Go to type definition | `plugins.lsp` (`vim.lsp.buf.type_definition`) |
| `K` | Normal | Display hover documentation / signature | `plugins.lsp` (`vim.lsp.buf.hover`) |
| `<leader>ca` | Normal | Open LSP code actions menu | `plugins.lsp` (`vim.lsp.buf.code_action`) |
| `<leader>cf` | Normal, Visual | Manually format buffer or visual selection | `conform-nvim` |
| `<leader>cr` / `<leader>rn` | Normal | Incremental LSP symbol rename with live preview | `inc-rename.nvim` |
| `[d` / `]d` | Normal | Jump to previous / next LSP diagnostic in file | `plugins.lsp` (`vim.diagnostic.goto_prev` / `vim.diagnostic.goto_next`) |
| `<leader>cd` | Normal | Open floating diagnostic details for current line | `plugins.lsp` (`vim.diagnostic.open_float`) |

---

## 7. Diagnostics, Quickfix & Location Lists

Managed by `trouble.nvim`, `todo-comments.nvim`, and Vim unimpaired navigation.

| Keybinding | Action | Plugin / Handler |
| :--- | :--- | :--- |
| `<leader>xx` | Toggle workspace diagnostics panel | `trouble.nvim` |
| `<leader>xX` / `<leader>xb` | Toggle current buffer diagnostics panel | `trouble.nvim` |
| `<leader>cs` | Toggle code symbols outline panel | `trouble.nvim` |
| `<leader>xL` / `<leader>xl` | Toggle location list | `trouble.nvim` |
| `<leader>xQ` / `<leader>xq` | Toggle quickfix list | `trouble.nvim` |
| `<leader>xt` | Toggle TODO items list | `trouble.nvim` |
| `]t` / `[t` | Jump to next / previous TODO comment in buffer | `todo-comments.nvim` |
| `]q` / `[q` | Jump to next / previous quickfix entry | Built-in (`:cnext` / `:cprev`) |
| `]l` / `[l` | Jump to next / previous location list entry | Built-in (`:lnext` / `:lprev`) |

---

## 8. Editing, Surround, Textobjects & Yank History

Managed by `mini.surround`, `nvim-treesitter-textobjects`, and `yanky.nvim`.

| Keybinding | Mode | Action | Plugin / Handler |
| :--- | :---: | :--- | :--- |
| `sa<motion><char>` | Normal, Visual | Add surrounding characters (e.g. `saiw"` surrounds word with `"`) | `mini.surround` |
| `sd<char>` | Normal | Delete surrounding characters (e.g. `sd"` removes `"`) | `mini.surround` |
| `sr<old><new>` | Normal | Replace surrounding characters (e.g. `sr"'` replaces `"` with `'`) | `mini.surround` |
| `af` / `if` | Visual, Operator | Outer / Inner function textobject motion | `treesitter-textobjects` |
| `ac` / `ic` | Visual, Operator | Outer / Inner class textobject motion | `treesitter-textobjects` |
| `aa` / `ia` | Visual, Operator | Outer / Inner parameter/argument textobject motion | `treesitter-textobjects` |
| `p` / `P` | Normal, Visual | Put after / before with clipboard history registration | `yanky.nvim` |
| `[y` / `]y` | Normal | Cycle backward / forward through yank history ring | `yanky.nvim` |

---

## 9. Undotree & Session Recovery

Managed by `undotree` and `persistence.nvim`.

| Keybinding | Action | Plugin / Handler |
| :--- | :--- | :--- |
| `<leader>u` | Toggle branching undo history tree sidebar | `undotree` |
| `<leader>ss` | Restore session for the current workspace directory | `persistence.nvim` |
| `<leader>sl` | Restore last active session | `persistence.nvim` |
| `<leader>sd` | Do not save session on editor exit | `persistence.nvim` |
| `<leader>sq` | Quit Neovim (all windows & buffers) | Built-in (`:qa`) |

---

## 10. Autocompletion

Managed by `blink-cmp` with `luasnip`.

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

## 11. Formatters (Auto Format on Save & `<leader>cf`)

Managed by `conform-nvim`. Automatically formats on `:w` or on `<leader>cf`:

* **Nix**: `alejandra`
* **Python**: `ruff_format`
* **Go**: `gofmt`, `goimports`
* **JavaScript / TypeScript / React / HTML / CSS / SCSS / JSON / JSONC / YAML / Markdown**: `prettier`
* **Shell**: `shfmt`

---

## 12. AI & CLI Sidekick (Claude Code, OpenCode, Antigravity)

Managed by `sidekick.nvim`.

| Keybinding | Mode | Action | Plugin / Handler |
| :--- | :---: | :--- | :--- |
| `<C-.>` | Normal, Terminal, Insert, Visual | Focus / Defocus active AI Sidekick CLI window | `sidekick.cli` |
| `<leader>aa` | Normal | Toggle Sidekick CLI (active/last session) | `sidekick.cli` |
| `<leader>as` | Normal | Select AI CLI tool from interactive picker | `sidekick.cli` |
| `<leader>ac` | Normal | Toggle Claude Code CLI directly | `sidekick.cli` |
| `<leader>ao` | Normal | Toggle OpenCode CLI directly | `sidekick.cli` |
| `<leader>ag` | Normal | Toggle Antigravity (`agy`) CLI directly | `sidekick.cli` |
| `<leader>ap` | Normal | Open interactive AI prompt library | `sidekick.cli` |
| `<leader>af` | Normal | Send current file to active AI CLI (keep editor focus) | `sidekick.cli` |
| `<leader>aF` | Normal | Send current file to active AI CLI & focus terminal | `sidekick.cli` |
| `<leader>av` | Visual | Send visual selection to active AI CLI (keep editor focus) | `sidekick.cli` |
| `<leader>aV` | Visual | Send visual selection to active AI CLI & focus terminal | `sidekick.cli` |
| `<leader>ad` | Normal | Close / detach current AI CLI session | `sidekick.cli` |

