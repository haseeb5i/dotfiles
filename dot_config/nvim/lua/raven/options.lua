-- set 'space' as leader key
vim.g.mapleader = " "

local options = {
  -- interface
  cursorline = true, -- highlight the current line
  hlsearch = false, -- highlight all matches on previous search pattern
  pumheight = 10, -- pop up menu height
  showmode = false, -- handled by statusline
  scrolloff = 8, -- show 8 lines of context when scrolling
  sidescrolloff = 8, -- for horizontal scrolling when nowrap is set
  signcolumn = "yes", -- always show the sign column
  splitbelow = true, -- force all horizontal splits to go below current window
  splitright = true, -- force all vertical splits to go to the right of current window
  -- title = true, -- show title in terminal based on open buffer

  -- editor
  clipboard = "unnamed", -- allows neovim to access the system clipboard
  ignorecase = true, -- ignore case in search patterns
  mouse = "a", -- allow the mouse to be used in neovim
  smartcase = true, -- smart case
  swapfile = false, -- creates a swapfile
  timeoutlen = 600, -- time to wait for a mapped sequence to complete (1000ms default)
  updatetime = 300, -- faster completion (4000ms default)
  undofile = true, -- enable persistent undo
  wrap = false, -- display lines as one long line

  -- numbers
  number = true, -- set numbered lines
  relativenumber = true, -- set relative numbered lines
  numberwidth = 3, -- set number column width (default 4)
  ruler = false,

  -- indenting, handled by vim-seluth plugin
  -- shiftwidth = 2, -- spaces to be inserted for each indent (default 8)
  -- tabstop = 2, -- insert 2 spaces for a tab (default 8)
  -- softtabstop = 2,
  -- expandtab = true, -- convert tabs to spaces
  -- smarttab = true,
  -- smartindent = true, -- make indenting smarter again
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

vim.opt.completeopt:append "menuone,noselect"
vim.opt.fillchars:append "foldclose:+"
vim.opt.shortmess:append "csI"
vim.opt.whichwrap:append "<,>,[,]"

-- neovide configuration
if vim.g.neovide then
  vim.opt.guifont = "FiraCode Nerd Font:h10"
  vim.g.neovide_scroll_animation_length = 0.2
  vim.g.neovide_confirm_quit = true
end

-- disable some builtin vim plugins
local default_plugins = {
  "2html_plugin",
  "gzip",
  "netrwPlugin",
  "matchit",
  "tarPlugin",
  "spellfile_plugin",
  "tutor",
  "zipPlugin",
}

for _, plugin in pairs(default_plugins) do
  vim.g["loaded_" .. plugin] = 1
end
