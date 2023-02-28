-- setup neovim options
require 'user.options'

-- setup auto commands
require 'user.autocmds'

-- setup plugins
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.notify 'installing lazy.nvim...'
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    '--single-branch',
    'https://github.com/folke/lazy.nvim.git',
    lazypath,
  }
end

vim.opt.runtimepath:prepend(lazypath)

require('lazy').setup('user.plugins', {
  defaults = {
    lazy = true,
  },
  ui = {
    border = 'rounded',
  },
  performance = {
    rtp = {
      reset = true,
      disabled_plugins = {
        'gzip',
        -- "matchit",
        -- "matchparen",
        'netrwPlugin',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
})

-- setup keymaps
require 'user.keymaps'
