-- Custom Autocommands
-- LazyVim loads this file automatically

-- Disable mini.indentscope for specific filetypes
vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "dashboard",
    "fzf",
    "help",
    "lazy",
    "lazyterm",
    "mason",
    "neo-tree",
    "notify",
    "toggleterm",
    "Trouble",
    "trouble",
    "snacks_dashboard",
  },
  callback = function()
    vim.b.miniindentscope_disable = true
  end,
})
