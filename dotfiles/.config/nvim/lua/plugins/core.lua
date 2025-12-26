-- Core: Colorscheme + Base plugins

return {
    {
        "rose-pine/neovim",
        name = "rose-pine",
        priority = 1000,
        opts = {
            variant = "main",
            dark_variant = "main",
            dim_inactive_windows = false,
            extend_background_behind_borders = true,
            styles = {
                bold = true,
                italic = false,
                transparency = false,
            },
            highlight_groups = {
                TelescopeBorder = { fg = "highlight_high", bg = "none" },
                TelescopeNormal = { bg = "none" },
                TelescopePromptNormal = { bg = "base" },
                TelescopeResultsNormal = { fg = "subtle", bg = "none" },
                TelescopeSelection = { fg = "text", bg = "base" },
                TelescopeSelectionCaret = { fg = "rose", bg = "rose" },
                StatusLine = { fg = "love", bg = "love", blend = 10 },
                StatusLineNC = { fg = "subtle", bg = "surface" },
                CursorLine = { bg = "foam", blend = 10 },
                FloatBorder = { fg = "highlight_high", bg = "none" },
                NormalFloat = { bg = "none" },
                Pmenu = { fg = "text", bg = "surface" },
                PmenuSel = { fg = "base", bg = "rose" },
                WinSeparator = { fg = "highlight_med" },
                RainbowDelimiterRed = { fg = "love" },
                RainbowDelimiterYellow = { fg = "gold" },
                RainbowDelimiterBlue = { fg = "foam" },
                RainbowDelimiterOrange = { fg = "rose" },
                RainbowDelimiterGreen = { fg = "pine" },
                RainbowDelimiterViolet = { fg = "iris" },
                RainbowDelimiterCyan = { fg = "foam" },
                AlphaHeader = { fg = "love" },
                AlphaButtons = { fg = "foam" },
                AlphaShortcut = { fg = "gold" },
                AlphaFooter = { fg = "subtle", italic = true },
                NoiceCmdlinePopupBorder = { fg = "foam" },
                NoiceCmdlineIcon = { fg = "rose" },
            },
        },
    },
    {
        "NickvanDyke/opencode.nvim",
        dependencies = {
            -- Recommended for `ask()` and `select()`.
            -- Required for `snacks` provider.
            ---@module 'snacks' <- Loads `snacks.nvim` types for configuration intellisense.
            { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
        },
        config = function()
            ---@type opencode.Opts
            vim.g.opencode_opts = {
                -- Your configuration, if any — see `lua/opencode/config.lua`, or "goto definition".
            }

            -- Required for `opts.events.reload`.
            vim.o.autoread = true

            -- Recommended/example keymaps.
            vim.keymap.set({ "n", "x" }, "<C-a>", function() require("opencode").ask("@this: ", { submit = true }) end,
                { desc = "Ask opencode" })
            vim.keymap.set({ "n", "x" }, "<C-x>", function() require("opencode").select() end,
                { desc = "Execute opencode action…" })
            vim.keymap.set({ "n", "t" }, "<C-.>", function() require("opencode").toggle() end,
                { desc = "Toggle opencode" })

            vim.keymap.set({ "n", "x" }, "go", function() return require("opencode").operator("@this ") end,
                { expr = true, desc = "Add range to opencode" })
            vim.keymap.set("n", "goo", function() return require("opencode").operator("@this ") .. "_" end,
                { expr = true, desc = "Add line to opencode" })

            vim.keymap.set("n", "<S-C-u>", function() require("opencode").command("session.half.page.up") end,
                { desc = "opencode half page up" })
            vim.keymap.set("n", "<S-C-d>", function() require("opencode").command("session.half.page.down") end,
                { desc = "opencode half page down" })

            -- You may want these if you stick with the opinionated "<C-a>" and "<C-x>" above — otherwise consider "<leader>o".
            vim.keymap.set("n", "+", "<C-a>", { desc = "Increment", noremap = true })
            vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement", noremap = true })
        end,
    }
}
