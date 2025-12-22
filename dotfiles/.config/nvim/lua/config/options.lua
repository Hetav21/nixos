-- Platform-specific Configuration

-- WSL: Enable clipboard integration via Windows clip.exe/PowerShell
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

-- Fix Node.js provider (set via Nix environment variable)
if vim.env.NEOVIM_NODE_HOST then
  vim.g.node_host_prog = vim.env.NEOVIM_NODE_HOST
end

-- Disable unused providers (performance)
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
