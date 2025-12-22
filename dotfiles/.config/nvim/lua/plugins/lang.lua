-- Languages: Custom LSP/Formatting overrides
-- (LazyVim lang extras are imported in extras.lua)

return {
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {},
      exclude = { "nil_ls" },
    },
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        nil_ls = {
          mason = false,
        },
      },
    },
  },
}
