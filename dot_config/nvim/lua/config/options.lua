-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.cmdheight = 0 -- hide command line unless needed
vim.opt.hlsearch = false -- highlight all matches on previous search pattern
-- vim.opt.numberwidth = 3 -- set number column width (default 4)
vim.opt.list = false -- Show some invisible characters (tabs...)

-- follow desktop theme (headless herdr sidebar skips terminal detection)
if vim.fn.executable("gsettings") == 1 then
  local scheme = vim.fn.system({ "gsettings", "get", "org.gnome.desktop.interface", "color-scheme" })
  vim.o.background = scheme:find("dark") and "dark" or "light"
end

-- lazyvim configuration
vim.g.ai_cmp = true
vim.g.autoformat = false

-- neovide configuration
if vim.g.neovide then
  vim.opt.guifont = "FiraCode Nerd Font:h14" -- or CaskaydiaCove Nerd Font
  vim.g.neovide_scroll_animation_length = 0.2
  vim.g.neovide_confirm_quit = true
  vim.g.neovide_transparency = 1
end
