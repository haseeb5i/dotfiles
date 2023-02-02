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

  -- editor
  clipboard = "unnamedplus", -- allows neovim to access the system clipboard
  ignorecase = true, -- ignore case in search patterns
  grepprg = "rg -S --vimgrep", -- use ripgrep for grepping in vim
  smartcase = true, -- smart case
  swapfile = false, -- creates a swapfile
  timeoutlen = 500, -- time to wait for a mapped sequence to complete (1000ms default)
  updatetime = 250, -- faster completion (4000ms default)
  undofile = true, -- enable persistent undo
  wrap = false, -- display lines as one long line

  -- numbers
  number = true, -- set numbered lines
  relativenumber = true, -- set relative numbered lines
  numberwidth = 3, -- set number column width (default 4)
  ruler = false,

  -- indenting, handled by vim-seluth
  -- shiftwidth = 2, -- no. of spaces for one indent (default 8)
  -- softtabstop = 2,
  -- tabstop = 2, -- insert 2 spaces for a tab (default 8)
  -- expandtab = true, -- convert tabs to spaces
  -- smarttab = true,
  -- smartindent = true, -- make indenting smarter again
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

vim.opt.fillchars:append "foldclose:+"
vim.opt.completeopt:append "menuone,noselect"
vim.opt.shortmess:append "csI"
vim.opt.whichwrap:append "<,>,[,]"

-- neovide configuration
if vim.g.neovide then
  vim.opt.guifont = "FiraCode Nerd Font:h11"
  vim.g.neovide_scroll_animation_length = 0.2
  vim.g.neovide_confirm_quit = true
  -- vim.g.neovide_transparency = 0.8
end
