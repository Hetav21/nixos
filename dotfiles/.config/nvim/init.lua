-- ============================================================================
-- Neovim Configuration with LazyVim
-- ============================================================================
-- Architecture:
--   Nix:  handles neovim installation + config bundling
--   Lua:  handles plugin management (lazy.nvim) + LSP installation (mason.nvim)
-- ============================================================================

-- Load platform-specific options
require("config.options")

-- ============================================================================
-- Get config directory (nixCats provides this when wrapped, fallback for dev)
-- ============================================================================

local configdir = nixCats and require("nixCats").configDir or vim.fn.stdpath("config")

-- ============================================================================
-- Bootstrap lazy.nvim
-- ============================================================================

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- ============================================================================
-- LazyVim Setup
-- ============================================================================

require("lazy").setup({
  spec = {
    -- 1. LazyVim core (must be first)
    {
      "LazyVim/LazyVim",
      import = "lazyvim.plugins",
      opts = { colorscheme = "rose-pine" },
    },
    -- 2. LazyVim extras
    { import = "plugins.extras" },
    -- 3. Custom plugins
    { import = "plugins.core" },
    { import = "plugins.coding" },
    { import = "plugins.editor" },
    { import = "plugins.lang" },
    { import = "plugins.tools" },
    { import = "plugins.ui" },
  },

  -- ==========================================================================
  -- Lazy.nvim Configuration
  -- ==========================================================================
  defaults = {
    lazy = false,
    version = false,
  },
  install = {
    colorscheme = { "rose-pine", "tokyonight", "habamax" },
  },
  checker = {
    enabled = true,
    notify = false,
  },
  rocks = {
    enabled = false, -- Disable luarocks (avoids hererocks issues)
  },
  performance = {
    rtp = {
      -- Keep nix store config dir in runtimepath for plugin spec imports
      paths = { configdir },
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
