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
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      vim.o.autoread = true
      vim.g.opencode_opts = {}
    end,
  },
}
