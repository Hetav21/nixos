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
      };

      globals = {
        mapleader = " ";
        maplocalleader = "\\";
        loaded_ruby_provider = 0;
        loaded_perl_provider = 0;
      };

      # System and CLI packages needed at runtime
      extraPackages = with pkgs; [
        ripgrep
        fd
        wl-clipboard
        # Formatters & Linters
        alejandra
        ruff
        black
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
              ["+"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
              ["*"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
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
            picker = {
              enabled = true;
              sources = {
                explorer = {
                  hidden = true;
                };
              };
            };
            explorer.enabled = true;
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
        which-key.enable = true;

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
            basedpyright.enable = true;
            ruff.enable = true;
            gopls.enable = true;
            clangd.enable = true;
            ts_ls.enable = true;
            tailwindcss.enable = true;
            nil_ls.enable = true;
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
              python = [
                "ruff_format"
                "black"
              ];
              go = [
                "gofmt"
                "goimports"
              ];
              javascript = ["prettier"];
              typescript = ["prettier"];
              javascriptreact = ["prettier"];
              typescriptreact = ["prettier"];
              json = ["prettier"];
              yaml = ["prettier"];
              markdown = ["prettier"];
              sh = ["shfmt"];
            };
          };
        };

        # Debug Adapter Protocol
        dap.enable = true;
      };

      # Clean Keybindings
      keymaps = [
        # Bufferline navigation & management
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
          action.__raw = "function() Snacks.bufdelete() end";
          options.desc = "Delete Buffer";
        }

        # Snacks Picker & Explorer
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
          key = "<leader>/";
          action.__raw = "function() Snacks.picker.grep() end";
          options.desc = "Grep";
        }
        {
          key = "<leader>fb";
          action.__raw = "function() Snacks.picker.buffers() end";
          options.desc = "Buffers";
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

        # Diffview & Git
        {
          key = "<leader>gd";
          action = "<cmd>DiffviewOpen<cr>";
          options.desc = "Diffview Open";
        }
        {
          key = "<leader>gh";
          action = "<cmd>DiffviewFileHistory %<cr>";
          options.desc = "File History";
        }
        {
          key = "<leader>gH";
          action = "<cmd>DiffviewFileHistory<cr>";
          options.desc = "Branch History";
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
          key = "<leader>hs";
          action = "<cmd>Gitsigns stage_hunk<cr>";
          options.desc = "Stage Hunk";
        }
        {
          key = "<leader>hr";
          action = "<cmd>Gitsigns reset_hunk<cr>";
          options.desc = "Reset Hunk";
        }
        {
          key = "<leader>hp";
          action = "<cmd>Gitsigns preview_hunk<cr>";
          options.desc = "Preview Hunk Inline";
        }
        {
          key = "<leader>hb";
          action = "<cmd>Gitsigns blame_line<cr>";
          options.desc = "Git Blame Line";
        }

        # Todo Comments
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

        # Yanky History
        {
          key = "[y";
          action = "<Plug>(YankyCycleBackward)";
          options.desc = "Cycle Backward Yank History";
        }
        {
          key = "]y";
          action = "<Plug>(YankyCycleForward)";
          options.desc = "Cycle Forward Yank History";
        }

        # Trouble Diagnostics
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
          key = "<leader>xQ";
          action = "<cmd>Trouble qflist toggle<cr>";
          options.desc = "Quickfix List (Trouble)";
        }

        # Undotree
        {
          key = "<leader>uu";
          action = "<cmd>UndotreeToggle<cr>";
          options.desc = "Toggle Undotree";
        }

        # Rename (IncRename)
        {
          key = "<leader>rn";
          action.__raw = ''function() return ":IncRename " .. vim.fn.expand("<cword>") end'';
          options = {
            expr = true;
            desc = "Incremental Rename";
          };
        }

        # Session persistence
        {
          key = "<leader>qs";
          action.__raw = ''function() require("persistence").load() end'';
          options.desc = "Restore Session";
        }
        {
          key = "<leader>ql";
          action.__raw = ''function() require("persistence").load({ last = true }) end'';
          options.desc = "Restore Last Session";
        }
        {
          key = "<leader>qd";
          action.__raw = ''function() require("persistence").stop() end'';
          options.desc = "Don't Save Current Session";
        }
      ];
    };
  };
})
args
