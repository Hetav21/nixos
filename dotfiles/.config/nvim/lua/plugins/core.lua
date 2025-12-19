-- Core: Colorscheme + Base plugins

return {
  {
    "rose-pine/neovim",
    name = "rose-pine",
    priority = 1000,
    opts = {
      variant = "main",
      dark_variant = "main",
      styles = {
        italic = false,
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
