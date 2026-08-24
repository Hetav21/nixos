# Neovim Keybindings Guide

Declarative Neovim configuration is managed via [Nixvim](https://github.com/nix-community/nixvim) in `modules/home/development/neovim.nix` (module `home.development.neovim`).

**Source of truth:** `modules/home/development/neovim.nix` — the single site configuring all options, plugins, language servers, formatters, and keybindings.

---

## Leader Keys

* **`<leader>`**: `Space`
* **`<localleader>`**: `\`

Pressing `<leader>` opens the **which-key** popup menu with categorized groups (AI / Sidekick, Buffer, Code, Find, Git, Session, UI / Toggle, Diagnostics/Trouble).

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
| `<leader>bc` | Close current buffer (preserves layout) | `snacks.bufdelete` |
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
| `<leader>fs` | Search LSP symbols in current buffer | `snacks.picker` |
| `<leader>fS` | Search LSP symbols across workspace | `snacks.picker` |
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
| `<leader>gg` | Normal | Open interactive Lazygit floating window | `snacks.lazygit` |
| `<leader>gB` | Normal | Open current file / repo in GitHub/browser | `snacks.gitbrowse` |
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

### Merge Conflict Resolution (`diffview.nvim`)

When merge or rebase conflicts occur, opening Diffview (`<leader>gd` or `:DiffviewOpen`) provides a 3-way split interface (`LOCAL`, `BASE`, `REMOTE` alongside the working buffer).

| Keybinding / Command | Mode | Action | Description |
| :--- | :---: | :--- | :--- |
| `]x` / `[x` | Normal | Next / Previous conflict | Jump between conflict markers across unmerged files |
| `]c` / `[c` | Normal | Next / Previous diff change | Jump between diff hunks |
| `<leader>co` | Normal | Choose **Ours** (`LOCAL`) | Accept current branch version |
| `<leader>ct` | Normal | Choose **Theirs** (`REMOTE`) | Accept incoming branch version |
| `<leader>cb` | Normal | Choose **Base** (`BASE`) | Accept common ancestor version |
| `<leader>ca` | Normal | Choose **All** | Keep both incoming and local changes |
| `<leader>c0` | Normal | Choose **None** | Discard both conflict regions |
| `:DiffviewClose` | Command | Close Diffview | Exit the conflict resolution interface after saving (`<C-s>`) |

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
| `<leader>cl` | Normal | Trigger manual linter diagnostics run | `nvim-lint` |
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

## 8. Editing, Surround, Auto-pairs & Yank History

Managed by `mini.surround`, `mini.pairs`, `nvim-ts-autotag`, `ts-comments.nvim`, `nvim-colorizer`, `nvim-treesitter-textobjects`, and `yanky.nvim`.

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

* **Auto-closing pairs**: Automatically inserts matching brackets (`(`, `[`, `{`) and quotes (`"`, `'`) via `mini.pairs`.
* **HTML/JSX autotag**: Automatically closes and renames paired HTML/JSX tags via `nvim-ts-autotag`.
* **Context-aware comments**: Automatically uses the right comment syntax in embedded language contexts (JSX, template strings) via `ts-comments.nvim`.
* **Color swatches**: Color codes (hex `#ea9a97`, RGB, Tailwind) rendered inline via `nvim-colorizer`.

---

## 9. Undotree, UI Toggles & Session Recovery

Managed by `undotree`, `snacks.toggle`, and `persistence.nvim`.

| Keybinding | Action | Plugin / Handler |
| :--- | :--- | :--- |
| `<leader>uu` | Toggle branching undo history tree sidebar | `undotree` |
| `<leader>ui` | Toggle LSP Inlay Hints on/off | `snacks.toggle` |
| `<leader>ud` | Toggle Diagnostics on/off | `snacks.toggle` |
| `<leader>uf` | Toggle Auto Format on/off globally | `snacks.toggle` |
| `<leader>ss` | Restore session for the current workspace directory | `persistence.nvim` |
| `<leader>sl` | Restore last active session | `persistence.nvim` |
| `<leader>sd` | Do not save session on editor exit | `persistence.nvim` |
| `<leader>sq` | Quit Neovim (all windows & buffers) | Built-in (`:qa`) |

---

## 10. Autocompletion & Snippets

Managed by `blink-cmp` with `luasnip` and `friendly-snippets`.

| Keybinding | Action | Plugin / Handler |
| :--- | :--- | :--- |
| `<Tab>` | Accept completion candidate / jump forward in snippet | `blink.cmp` |
| `<S-Tab>` | Jump backward in snippet | `blink.cmp` |
| `<CR>` (Enter) | Confirm / accept selected completion candidate | `blink.cmp` |
| `<C-e>` | Dismiss / hide active completion popup and ghost text | `blink.cmp` |
| `<C-Space>` | Open completion popup / toggle documentation preview | `blink.cmp` |
| `<C-j>` / `<C-n>` | Select next completion item | `blink.cmp` |
| `<C-k>` / `<C-p>` | Select previous completion item | `blink.cmp` |
| `<C-d>` / `<C-u>` | Scroll documentation preview down / up | `blink.cmp` |

---

## 11. Formatters & Linters

* **Format on Save & `<leader>cf` (`conform-nvim`)**:
  * **Nix**: `alejandra`
  * **Python**: `ruff_organize_imports`, `ruff_format`
  * **Go**: `gofmt`, `goimports`
  * **JavaScript / TypeScript / React / HTML / CSS / SCSS / JSON / JSONC / YAML / Markdown**: `prettier`
  * **TOML**: `taplo`
  * **Shell / Bash**: `shfmt`
* **Linter Diagnostics (`nvim-lint` & `<leader>cl`)**:
  * **Shell / Bash**: `shellcheck`
  * **Nix**: `statix`
  * **Markdown**: `markdownlint-cli2`

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

