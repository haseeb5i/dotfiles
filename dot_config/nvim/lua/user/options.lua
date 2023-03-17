-- set 'space' as leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local options = {
  -- interface
  cmdheight = 0, -- hide command line unless needed
  cursorline = true, -- highlight the current line
  confirm = true, -- confirm to save changes before exiting modified buffer
  hlsearch = false, -- highlight all matches on previous search pattern
  pumheight = 10, -- maximum items to show in popup menu
  showmode = false, -- handled by statusline
  scrolloff = 8, -- show 8 lines of context when scrolling
  sidescrolloff = 8, -- for horizontal scrolling when nowrap is set
  signcolumn = "yes", -- always show the sign column
  splitbelow = true, -- force all horizontal splits to go below current window
  splitright = true, -- force all vertical splits to go to the right of current window
  termguicolors = true, -- true color support

  -- editor
  clipboard = "unnamedplus", -- allows neovim to access the system clipboard
  ignorecase = true, -- ignore case in search patterns
  grepprg = "rg -S --vimgrep", -- use ripgrep for grepping in vim
  grepformat = "%f:%l:%c:%m",
  number = true, -- set numbered lines
  numberwidth = 3, -- set number column width (default 4)
  relativenumber = true, -- set relative numbered lines
  smartcase = true, -- smart case
  swapfile = false, -- creates a swapfile
  timeoutlen = 400, -- time to wait for a mapped sequence (1000ms default)
  updatetime = 250, -- faster completion (4000ms default)
  undofile = true, -- enable persistent undo
  wrap = false, -- display lines as one long line

  -- indenting
  shiftwidth = 4, -- no. of spaces for one indent (default 8)
  tabstop = 4, -- insert x spaces for a tab (default 8)
  expandtab = true, -- convert tabs to spaces
  smartindent = true, -- make indenting smarter again
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

vim.opt.completeopt = "menu,menuone,noselect"
vim.opt.shortmess:append "sI"
vim.opt.whichwrap:append "<,>,[,]"

if vim.fn.has "nvim-0.9" == 1 then
  splitkeep = "screen" -- maintain code view when splitting
  vim.opt.diffopt:append "linematch:60" -- enable linematch diff algorithm
end

-- neovide configuration
if vim.g.neovide then
  vim.opt.guifont = "FiraCode Nerd Font:h11" -- CaskaydiaCove Nerd Font
  vim.g.neovide_scroll_animation_length = 0.2
  vim.g.neovide_confirm_quit = true
  -- vim.g.neovide_transparency = 0.8
end
