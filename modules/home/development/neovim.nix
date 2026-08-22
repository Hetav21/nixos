{
  extraLib,
  pkgs,
  ...
} @ args:
(extraLib.modules.mkModule {
  name = "home.development.neovim";
  hasCli = true;
  hasGui = false;
  cliConfig = _: {
    stylix.targets.nixvim.enable = false;

    home.shellAliases = {
      nv = "nvim";
    };

    programs.nixvim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;

      # Use system/home-manager pkgs instance (reusing overlays and suppressing follows warning)
      nixpkgs.useGlobalPackages = true;

      # Rosé Pine Colorscheme
      colorschemes.rose-pine = {
        enable = true;
        settings = {
          variant = "main";
          dark_variant = "main";
          dim_inactive_windows = false;
          extend_background_behind_borders = true;
          styles = {
            bold = true;
            italic = true;
            transparency = false;
          };
        };
      };

      # Editor Options
      opts = {
        number = true;
        relativenumber = true;
        shiftwidth = 2;
        tabstop = 2;
        softtabstop = 2;
        expandtab = true;
        smartindent = true;
        ignorecase = true;
        smartcase = true;
        termguicolors = true;
        undofile = true;
        updatetime = 200;
        timeoutlen = 300;
        splitbelow = true;
        splitright = true;
        mouse = "a";
        clipboard = "unnamedplus";
        signcolumn = "yes";
        cursorline = true;
        scrolloff = 8;
        sidescrolloff = 8;
        wrap = false;
        confirm = true;
        virtualedit = "block";
        inccommand = "split";
        smoothscroll = true;
        list = true;
        listchars = {
          tab = "» ";
          trail = "·";
          nbsp = "␣";
        };
        fillchars = {
          eob = " ";
        };
        sessionoptions = [
          "buffers"
          "curdir"
          "tabpages"
          "winsize"
          "help"
          "globals"
          "skiprtp"
          "folds"
        ];
      };

      globals = {
        mapleader = " ";
        maplocalleader = "\\";
        loaded_ruby_provider = 0;
        loaded_perl_provider = 0;
        loaded_netrw = 1;
        loaded_netrwPlugin = 1;
      };

      # System and CLI packages needed at runtime
      extraPackages = with pkgs; [
        ripgrep
        fd
        wl-clipboard
        # Formatters & Linters
        alejandra
        ruff
        shellcheck
        prettier
        shfmt
      ];

      # Native Wayland clipboard
      clipboard.providers.wl-copy.enable = true;

      # WSL Clipboard integration & performance options
      extraConfigLua = ''
        if vim.fn.has("wsl") == 1 then
          vim.g.clipboard = {
            name = "WslClipboard",
            copy = {
              ["+"] = "clip.exe",
              ["*"] = "clip.exe",
            },
            paste = {
              ["+"] = [[powershell.exe -NoProfile -NonInteractive -Command '[Console]::Out.Write($(Get-Clipboard -Raw) -replace "\r", "")']],
              ["*"] = [[powershell.exe -NoProfile -NonInteractive -Command '[Console]::Out.Write($(Get-Clipboard -Raw) -replace "\r", "")']],
            },
            cache_enabled = 0,
          }
        end
      '';

      plugins = {
        # Modern QoL Suite (replaces telescope, neo-tree, illuminate, toggleterm, etc.)
        snacks = {
          enable = true;
          settings = {
            bigfile.enabled = true;
            quickfile.enabled = true;
            input.enabled = true;
            scope.enabled = true;
            scratch.enabled = true;
            dashboard = {
              enabled = true;
              preset = {
                header = ''
                  ╭─────────────────────────────────────────────────────────╮
                  │  ● ● ●                                                  │
                  │                                                         │
                  │     ██╗                                                 │
                  │     ╚██╗                                                │
                  │      ╚██╗                                               │
                  │       ╚██╗                                              │
                  │       ██╔╝   ██████████████████████████████╗            │
                  │      ██╔╝    ╚═════════════════════════════╝            │
                  │     ██╔╝                                                │
                  │     ╚═╝                                                 │
                  │                                                         │
                  │               >_ build something awesome                │
                  ╰─────────────────────────────────────────────────────────╯
                '';
                keys = [
                  {
                    icon = " ";
                    key = "f";
                    desc = "Find File";
                    action = ":lua Snacks.dashboard.pick('files')";
                  }
                  {
                    icon = " ";
                    key = "g";
                    desc = "Find Text";
                    action = ":lua Snacks.dashboard.pick('live_grep')";
                  }
                  {
                    icon = "󰄱 ";
                    key = "t";
                    desc = "Find TODOs";
                    action = ":lua Snacks.dashboard.pick('todo_comments')";
                  }
                  {
                    icon = " ";
                    key = "e";
                    desc = "File Explorer";
                    action = ":lua Snacks.explorer()";
                  }
                  {
                    icon = "󰊢 ";
                    key = "gs";
                    desc = "Git Status";
                    action = ":lua Snacks.dashboard.pick('git_status')";
                  }
                  {
                    icon = " ";
                    key = "gd";
                    desc = "Git Diff Viewer";
                    action = ":DiffviewOpen";
                  }
                  {
                    icon = " ";
                    key = "S";
                    desc = "Restore Session";
                    action = ":lua require('persistence').load()";
                  }
                  {
                    icon = " ";
                    key = "q";
                    desc = "Quit";
                    action = ":qa";
                  }
                ];
              };
              sections = [
                {
                  section = "header";
                }
                {
                  section = "keys";
                  gap = 1;
                  padding = 1;
                }
              ];
            };
            picker = {
              enabled = true;
              hidden = true;
              sources = {
                files = {
                  hidden = true;
                };
                grep = {
                  hidden = true;
                };
                explorer = {
                  hidden = true;
                };
              };
            };
            explorer = {
              enabled = true;
              replace_netrw = false;
            };
            notifier.enabled = true;
            bufdelete.enabled = true;
            indent.enabled = true;
            scroll.enabled = true;
            words.enabled = true;
            terminal.enabled = true;
            statuscolumn.enabled = true;
          };
        };

        # Ultra-fast Autocompletion
        blink-cmp = {
          enable = true;
          settings = {
            snippets = {
              preset = "luasnip";
            };
            keymap = {
              "<Tab>" = [
                "select_and_accept"
                "snippet_forward"
                "fallback"
              ];
              "<S-Tab>" = [
                "snippet_backward"
                "fallback"
              ];
              "<CR>" = [
                "accept"
                "fallback"
              ];
              "<C-Space>" = [
                "show"
                "show_documentation"
                "hide_documentation"
              ];
              "<C-n>" = [
                "select_next"
                "fallback"
              ];
              "<C-p>" = [
                "select_prev"
                "fallback"
              ];
              "<C-j>" = [
                "select_next"
                "fallback"
              ];
              "<C-k>" = [
                "select_prev"
                "fallback"
              ];
              "<C-d>" = [
                "scroll_documentation_down"
                "fallback"
              ];
              "<C-u>" = [
                "scroll_documentation_up"
                "fallback"
              ];
            };
            completion = {
              list.selection = {
                preselect = true;
                auto_insert = true;
              };
              menu.draw.treesitter = ["lsp"];
              documentation = {
                auto_show = true;
                auto_show_delay_ms = 100;
              };
              ghost_text.enabled = true;
            };
            signature.enabled = false;
          };
        };

        # Snippets
        luasnip.enable = true;

        # Surround motions (sa, sd, sr)
        mini = {
          enable = true;
          mockDevIcons = false;
          modules = {
            surround = {};
          };
        };

        # Yank history & clipboard ring
        yanky.enable = true;

        # Live rename
        inc-rename.enable = true;

        # TODO comments
        todo-comments.enable = true;

        # Better Quickfix
        nvim-bqf.enable = true;

        # Undo Tree
        undotree.enable = true;

        # Session saving
        persistence.enable = true;

        # Keymap helper
        which-key = {
          enable = true;
          settings = {
            preset = "helix";
            spec = [
              {
                __unkeyed-1 = "<leader>b";
                group = "Buffer";
                icon = "󰓩 ";
              }
              {
                __unkeyed-1 = "<leader>c";
                group = "Code";
                icon = "󰅩 ";
              }
              {
                __unkeyed-1 = "<leader>f";
                group = "Find";
                icon = "󰈞 ";
              }
              {
                __unkeyed-1 = "<leader>g";
                group = "Git";
                icon = "󰊢 ";
              }
              {
                __unkeyed-1 = "<leader>gh";
                group = "Hunks";
                icon = "󰊢 ";
              }
              {
                __unkeyed-1 = "<leader>s";
                group = "Session";
                icon = "󰗼 ";
              }
              {
                __unkeyed-1 = "<leader>x";
                group = "Diagnostics/Trouble";
                icon = "󱖫 ";
              }
              {
                __unkeyed-1 = "[";
                group = "Prev";
              }
              {
                __unkeyed-1 = "]";
                group = "Next";
              }
            ];
          };
        };

        # Git integration
        gitsigns.enable = true;
        diffview.enable = true;

        # Diagnostics panel
        trouble.enable = true;

        # Icons & Breadcrumbs
        web-devicons.enable = true;
        dropbar.enable = true;

        # Markdown rendering
        render-markdown.enable = true;

        # Statusline
        lualine = {
          enable = true;
          settings = {
            options = {
              globalstatus = true;
              theme = "auto";
            };
          };
        };

        # Buffer Tabs
        bufferline = {
          enable = true;
          settings = {
            options = {
              mode = "buffers";
              always_show_bufferline = true;
              diagnostics = "nvim_lsp";
              offsets = [
                {
                  filetype = "snacks_layout_box";
                  text = "File Explorer";
                  text_align = "center";
                  separator = true;
                }
                {
                  filetype = "undotree";
                  text = "Undo Tree";
                  text_align = "center";
                  separator = true;
                }
              ];
            };
          };
        };

        # Modern Cmdline & Notifications
        noice = {
          enable = true;
          settings = {
            notify.enabled = false; # Let snacks.notifier handle notifications
            lsp.signature.enabled = true;
            presets = {
              bottom_search = false;
              command_palette = true;
              long_message_to_split = true;
              inc_rename = true;
              lsp_doc_border = true;
            };
          };
        };
        nui.enable = true;

        # Treesitter Syntax Highlighting & Context
        treesitter = {
          enable = true;
          settings = {
            highlight.enable = true;
            indent.enable = true;
          };
        };
        treesitter-context.enable = true;
        treesitter-textobjects = {
          enable = true;
          settings = {
            select = {
              enable = true;
              lookahead = true;
              keymaps = {
                "af" = "@function.outer";
                "if" = "@function.inner";
                "ac" = "@class.outer";
                "ic" = "@class.inner";
                "aa" = "@parameter.outer";
                "ia" = "@parameter.inner";
              };
            };
          };
        };

        # Language Server Protocol (LSP)
        lsp = {
          enable = true;
          inlayHints = false;
          keymaps = {
            silent = true;
            diagnostic = {
              "[d" = "goto_prev";
              "]d" = "goto_next";
              "<leader>cd" = "open_float";
            };
            lspBuf = {
              "gd" = "definition";
              "gD" = "declaration";
              "gi" = "implementation";
              "gr" = "references";
              "gy" = "type_definition";
              "K" = "hover";
              "<leader>ca" = "code_action";
            };
          };
          servers = {
            basedpyright = {
              enable = true;
              settings.basedpyright.analysis = {
                autoImportCompletions = true;
                typeCheckingMode = "standard";
                diagnosticSeverityOverrides.reportUnusedImport = "none";
              };
            };
            ruff = {
              enable = true;
              onAttach.function = "client.server_capabilities.hoverProvider = false";
            };
            gopls.enable = true;
            clangd.enable = true;
            ts_ls.enable = true;
            tailwindcss.enable = true;
            nil_ls = {
              enable = true;
              settings.nil = {
                formatting.command = ["alejandra"];
                nix.flake.autoArchive = true;
              };
            };
            bashls.enable = true;
            jsonls.enable = true;
            yamlls.enable = true;
            taplo.enable = true;
            dockerls.enable = true;
          };
        };

        # Formatting on Save
        conform-nvim = {
          enable = true;
          settings = {
            format_on_save = {
              lsp_format = "fallback";
              timeout_ms = 1000;
            };
            formatters_by_ft = {
              nix = ["alejandra"];
              python = ["ruff_format"];
              go = [
                "gofmt"
                "goimports"
              ];
              javascript = ["prettier"];
              typescript = ["prettier"];
              javascriptreact = ["prettier"];
              typescriptreact = ["prettier"];
              html = ["prettier"];
              css = ["prettier"];
              scss = ["prettier"];
              json = ["prettier"];
              jsonc = ["prettier"];
              yaml = ["prettier"];
              markdown = ["prettier"];
              sh = ["shfmt"];
            };
          };
        };

        # Debug Adapter Protocol
        dap.enable = true;
      };

      # Clean, Ergonomic Keybindings
      keymaps = [
        # --- Navigation & Window Management ---
        {
          mode = "n";
          key = "<C-h>";
          action = "<C-w>h";
          options.desc = "Go to Left Window";
        }
        {
          mode = "n";
          key = "<C-j>";
          action = "<C-w>j";
          options.desc = "Go to Lower Window";
        }
        {
          mode = "n";
          key = "<C-k>";
          action = "<C-w>k";
          options.desc = "Go to Upper Window";
        }
        {
          mode = "n";
          key = "<C-l>";
          action = "<C-w>l";
          options.desc = "Go to Right Window";
        }

        # --- Visual Mode & Text Manipulation ---
        {
          mode = "v";
          key = "<";
          action = "<gv";
          options.desc = "Indent Left (Keep Selection)";
        }
        {
          mode = "v";
          key = ">";
          action = ">gv";
          options.desc = "Indent Right (Keep Selection)";
        }
        {
          mode = "v";
          key = "J";
          action = ":m '>+1<cr>gv=gv";
          options.desc = "Move Selection Down";
        }
        {
          mode = "v";
          key = "K";
          action = ":m '<-2<cr>gv=gv";
          options.desc = "Move Selection Up";
        }
        {
          mode = "n";
          key = "<Esc>";
          action = "<cmd>noh<cr><Esc>";
          options.desc = "Clear Search Highlights";
        }
        {
          mode = [
            "n"
            "i"
            "v"
          ];
          key = "<C-s>";
          action = "<cmd>w<cr><esc>";
          options.desc = "Save File";
        }

        # --- Bufferline & Buffer Management ---
        {
          key = "<leader>bp";
          action = "<cmd>BufferLineTogglePin<cr>";
          options.desc = "Toggle Pin";
        }
        {
          key = "<leader>bP";
          action = "<cmd>BufferLineGroupClose ungrouped<cr>";
          options.desc = "Delete Non-Pinned Buffers";
        }
        {
          key = "<leader>bo";
          action.__raw = "function() Snacks.bufdelete.other() end";
          options.desc = "Delete Other Buffers";
        }
        {
          key = "<leader>br";
          action = "<cmd>BufferLineCloseRight<cr>";
          options.desc = "Delete Buffers to the Right";
        }
        {
          key = "<leader>bl";
          action = "<cmd>BufferLineCloseLeft<cr>";
          options.desc = "Delete Buffers to the Left";
        }
        {
          key = "<S-h>";
          action = "<cmd>BufferLineCyclePrev<cr>";
          options.desc = "Prev Buffer";
        }
        {
          key = "<S-l>";
          action = "<cmd>BufferLineCycleNext<cr>";
          options.desc = "Next Buffer";
        }
        {
          key = "[b";
          action = "<cmd>BufferLineCyclePrev<cr>";
          options.desc = "Prev Buffer";
        }
        {
          key = "]b";
          action = "<cmd>BufferLineCycleNext<cr>";
          options.desc = "Next Buffer";
        }
        {
          key = "[B";
          action = "<cmd>BufferLineMovePrev<cr>";
          options.desc = "Move Buffer Left";
        }
        {
          key = "]B";
          action = "<cmd>BufferLineMoveNext<cr>";
          options.desc = "Move Buffer Right";
        }
        {
          key = "<leader>bd";
          action.__raw = "function() Snacks.dashboard() end";
          options.desc = "Open Dashboard";
        }

        # --- Find, Pickers & Terminal ---
        {
          key = "<leader><space>";
          action.__raw = "function() Snacks.picker.files() end";
          options.desc = "Find Files";
        }
        {
          key = "<leader>ff";
          action.__raw = "function() Snacks.picker.files() end";
          options.desc = "Find Files";
        }
        {
          key = "<leader>fr";
          action.__raw = "function() Snacks.picker.recent() end";
          options.desc = "Recent Files";
        }
        {
          key = "<leader>/";
          action.__raw = "function() Snacks.picker.grep() end";
          options.desc = "Grep Search";
        }
        {
          key = "<leader>fg";
          action.__raw = "function() Snacks.picker.grep() end";
          options.desc = "Grep Search";
        }
        {
          key = "<leader>fb";
          action.__raw = "function() Snacks.picker.buffers() end";
          options.desc = "Buffers";
        }
        {
          key = "<leader>fw";
          action.__raw = "function() Snacks.picker.grep_word() end";
          options.desc = "Search Word Under Cursor";
        }
        {
          key = "<leader>fl";
          action.__raw = "function() Snacks.picker.lines() end";
          options.desc = "Search Buffer Lines";
        }
        {
          key = "<leader>fk";
          action.__raw = "function() Snacks.picker.keymaps() end";
          options.desc = "Search Keymaps";
        }
        {
          key = "<leader>fh";
          action.__raw = "function() Snacks.picker.help() end";
          options.desc = "Search Help Tags";
        }
        {
          key = "<leader>fq";
          action.__raw = "function() Snacks.picker.qflist() end";
          options.desc = "Search Quickfix";
        }
        {
          key = "<leader>f.";
          action.__raw = "function() Snacks.picker.resume() end";
          options.desc = "Resume Last Picker";
        }
        {
          key = "<leader>ft";
          action.__raw = "function() Snacks.picker.todo_comments() end";
          options.desc = "Search TODOs";
        }
        {
          key = "<leader>fp";
          action.__raw = "function() if Snacks.picker.yanky then Snacks.picker.yanky() else Snacks.picker.registers() end end";
          options.desc = "Yank History Picker";
        }
        {
          key = "<leader>fR";
          action.__raw = "function() Snacks.picker.registers() end";
          options.desc = "Registers Picker";
        }
        {
          key = "<leader>fm";
          action.__raw = "function() Snacks.picker.marks() end";
          options.desc = "Marks Picker";
        }
        {
          key = "<leader>fc";
          action.__raw = "function() Snacks.picker.command_history() end";
          options.desc = "Command History";
        }
        {
          key = "<leader>fn";
          action.__raw = "function() Snacks.notifier.show_history() end";
          options.desc = "Notification History";
        }
        {
          key = "<leader>bs";
          action.__raw = "function() Snacks.scratch() end";
          options.desc = "Toggle Scratchpad";
        }
        {
          key = "<leader>e";
          action.__raw = "function() Snacks.explorer() end";
          options.desc = "File Explorer";
        }
        {
          mode = [
            "n"
            "t"
          ];
          key = "<C-\\>";
          action.__raw = "function() Snacks.terminal.toggle() end";
          options.desc = "Toggle Terminal";
        }

        # --- Code & LSP Actions ---
        {
          mode = [
            "n"
            "v"
          ];
          key = "<leader>cf";
          action.__raw = ''function() require("conform").format({ async = true, lsp_format = "fallback" }) end'';
          options.desc = "Format Document / Selection";
        }
        {
          key = "<leader>cr";
          action.__raw = ''function() return ":IncRename " .. vim.fn.expand("<cword>") end'';
          options = {
            expr = true;
            desc = "Incremental Rename";
          };
        }
        {
          key = "<leader>rn";
          action.__raw = ''function() return ":IncRename " .. vim.fn.expand("<cword>") end'';
          options = {
            expr = true;
            desc = "Incremental Rename (Alias)";
          };
        }

        # --- Git & Diffview ---
        {
          key = "<leader>gd";
          action = "<cmd>DiffviewOpen<cr>";
          options.desc = "Diffview Open";
        }
        {
          key = "<leader>gf";
          action = "<cmd>DiffviewFileHistory %<cr>";
          options.desc = "File History";
        }
        {
          key = "<leader>gH";
          action = "<cmd>DiffviewFileHistory<cr>";
          options.desc = "Branch History";
        }
        {
          key = "<leader>gs";
          action.__raw = "function() Snacks.picker.git_status() end";
          options.desc = "Git Status";
        }
        {
          key = "<leader>gl";
          action.__raw = "function() Snacks.picker.git_log() end";
          options.desc = "Git Log";
        }
        {
          key = "<leader>gb";
          action = "<cmd>Gitsigns blame_line<cr>";
          options.desc = "Git Blame Line";
        }
        {
          key = "<leader>gp";
          action = "<cmd>Gitsigns preview_hunk<cr>";
          options.desc = "Preview Hunk Inline";
        }
        {
          key = "]c";
          action = "<cmd>Gitsigns next_hunk<cr>";
          options.desc = "Next Git Hunk";
        }
        {
          key = "[c";
          action = "<cmd>Gitsigns prev_hunk<cr>";
          options.desc = "Prev Git Hunk";
        }
        {
          mode = [
            "n"
            "v"
          ];
          key = "<leader>ghs";
          action = "<cmd>Gitsigns stage_hunk<cr>";
          options.desc = "Stage Hunk";
        }
        {
          mode = [
            "n"
            "v"
          ];
          key = "<leader>ghr";
          action = "<cmd>Gitsigns reset_hunk<cr>";
          options.desc = "Reset Hunk";
        }
        {
          key = "<leader>ghp";
          action = "<cmd>Gitsigns preview_hunk<cr>";
          options.desc = "Preview Hunk Inline";
        }
        {
          key = "<leader>ghu";
          action = "<cmd>Gitsigns undo_stage_hunk<cr>";
          options.desc = "Undo Stage Hunk";
        }

        # --- Todo Comments ---
        {
          key = "]t";
          action.__raw = ''function() require("todo-comments").jump_next() end'';
          options.desc = "Next Todo Comment";
        }
        {
          key = "[t";
          action.__raw = ''function() require("todo-comments").jump_prev() end'';
          options.desc = "Previous Todo Comment";
        }

        # --- Yanky History ---
        {
          mode = [
            "n"
            "x"
          ];
          key = "p";
          action = "<Plug>(YankyPutAfter)";
          options = {
            remap = true;
            desc = "Put After (Yanky)";
          };
        }
        {
          mode = [
            "n"
            "x"
          ];
          key = "P";
          action = "<Plug>(YankyPutBefore)";
          options = {
            remap = true;
            desc = "Put Before (Yanky)";
          };
        }
        {
          key = "[y";
          action = "<Plug>(YankyCycleBackward)";
          options = {
            remap = true;
            desc = "Cycle Backward Yank History";
          };
        }
        {
          key = "]y";
          action = "<Plug>(YankyCycleForward)";
          options = {
            remap = true;
            desc = "Cycle Forward Yank History";
          };
        }

        # --- Trouble Diagnostics & Quickfix ---
        {
          key = "<leader>xx";
          action = "<cmd>Trouble diagnostics toggle<cr>";
          options.desc = "Diagnostics (Trouble)";
        }
        {
          key = "<leader>xX";
          action = "<cmd>Trouble diagnostics toggle filter.buf=0<cr>";
          options.desc = "Buffer Diagnostics (Trouble)";
        }
        {
          key = "<leader>xb";
          action = "<cmd>Trouble diagnostics toggle filter.buf=0<cr>";
          options.desc = "Buffer Diagnostics (Trouble)";
        }
        {
          key = "<leader>cs";
          action = "<cmd>Trouble symbols toggle focus=false<cr>";
          options.desc = "Symbols (Trouble)";
        }
        {
          key = "<leader>xL";
          action = "<cmd>Trouble loclist toggle<cr>";
          options.desc = "Location List (Trouble)";
        }
        {
          key = "<leader>xl";
          action = "<cmd>Trouble loclist toggle<cr>";
          options.desc = "Location List (Trouble)";
        }
        {
          key = "<leader>xQ";
          action = "<cmd>Trouble qflist toggle<cr>";
          options.desc = "Quickfix List (Trouble)";
        }
        {
          key = "<leader>xq";
          action = "<cmd>Trouble qflist toggle<cr>";
          options.desc = "Quickfix List (Trouble)";
        }
        {
          key = "<leader>xt";
          action = "<cmd>Trouble todo toggle<cr>";
          options.desc = "Todo List (Trouble)";
        }

        # --- Unimpaired Quickfix & Location Navigation ---
        {
          key = "[q";
          action = "<cmd>cprev<cr>";
          options.desc = "Previous Quickfix Entry";
        }
        {
          key = "]q";
          action = "<cmd>cnext<cr>";
          options.desc = "Next Quickfix Entry";
        }
        {
          key = "[l";
          action = "<cmd>lprev<cr>";
          options.desc = "Previous Location Entry";
        }
        {
          key = "]l";
          action = "<cmd>lnext<cr>";
          options.desc = "Next Location Entry";
        }

        # --- Undotree ---
        {
          key = "<leader>u";
          action = "<cmd>UndotreeToggle<cr>";
          options.desc = "Toggle Undotree";
        }

        # --- Session Persistence & Quit ---
        {
          key = "<leader>ss";
          action.__raw = ''function() require("persistence").load() end'';
          options.desc = "Restore Session";
        }
        {
          key = "<leader>sl";
          action.__raw = ''function() require("persistence").load({ last = true }) end'';
          options.desc = "Restore Last Session";
        }
        {
          key = "<leader>sd";
          action.__raw = ''function() require("persistence").stop() end'';
          options.desc = "Don't Save Current Session";
        }
        {
          key = "<leader>sq";
          action = "<cmd>qa<cr>";
          options.desc = "Quit Neovim (All)";
        }
      ];
    };
  };
})
args
