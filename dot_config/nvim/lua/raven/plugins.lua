-- bootstrap packer if not installed
local install_path = vim.fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
local is_bootstrap = false
if not vim.loop.fs_stat(install_path) then
  is_bootstrap = true
  vim.notify "installing packer..."
  vim.fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  vim.cmd.packadd "packer.nvim"
end

vim.api.nvim_create_augroup("_packer_config", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
  command = "source <afile> | PackerCompile",
  group = "_packer_config",
  pattern = "plugins.lua",
})

local packer = require "packer"

packer.init {
  auto_clean = true,
  display = {
    working_sym = "ﲊ",
    error_sym = "✗ ",
    done_sym = " ",
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}

return packer.startup(function(use)
  use "wbthomason/packer.nvim"
  use "nvim-lua/plenary.nvim"
  use "lewis6991/impatient.nvim"

  -- telescope for fuzzy finding
  use {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.0",
    cmd = "Telescope",
    config = function()
      require "raven.core.telescope"
    end,
  }
  use {
    "nvim-telescope/telescope-fzf-native.nvim",
    run = "make",
  }

  -- treesitter for syntax highlighting
  use {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      require "raven.core.treesitter"
    end,
    run = function()
      require("nvim-treesitter.install").update { with_sync = true }()
    end,
  }
  use {
    "nvim-treesitter/nvim-treesitter-textobjects",
    after = "nvim-treesitter",
  }
  use { "windwp/nvim-ts-autotag", event = "InsertEnter" }
  use {
    "p00f/nvim-ts-rainbow",
    event = { "CursorHold", "CursorHoldI" },
  }
  use {
    "nvim-treesitter/playground",
    cmd = { "TSPlaygroundToggle", "TSCaptureUnderCursor" },
  }

  -- completion stuff
  use {
    "rafamadriz/friendly-snippets",
    event = { "CmdlineEnter", "InsertEnter" },
  }
  use { "L3MON4D3/LuaSnip", after = "friendly-snippets" }
  use {
    "hrsh7th/nvim-cmp",
    after = "LuaSnip",
    config = function()
      require "raven.core.completion"
    end,
  }
  use { "hrsh7th/cmp-nvim-lsp", module = "cmp_nvim_lsp" }
  use { "saadparwaiz1/cmp_luasnip", after = "nvim-cmp" }
  use { "hrsh7th/cmp-nvim-lua", after = "cmp_luasnip" }
  use { "hrsh7th/cmp-buffer", after = "cmp-nvim-lua" }
  use { "hrsh7th/cmp-path", after = "cmp-buffer" }
  use { "hrsh7th/cmp-cmdline", after = "cmp-path" }

  -- lsp stuff
  use "williamboman/mason.nvim"
  use "williamboman/mason-lspconfig.nvim"
  use {
    "neovim/nvim-lspconfig",
    config = function()
      require "raven.lsp.lspconfig"
    end,
  }
  use { "b0o/schemastore.nvim", module = "schemastore" }
  use { "scalameta/nvim-metals", module = "metals" }
  use {
    "jose-elias-alvarez/null-ls.nvim",
    after = "nvim-lspconfig",
    config = function()
      require "raven.lsp.null-ls"
    end,
  }
  use {
    "j-hui/fidget.nvim",
    config = function()
      require "raven.lsp.fidget"
    end,
  }

  -- debugging stuff
  -- use {
  --   "mfussenegger/nvim-dap",
  --   module = "dap",
  --   config = function()
  --     require "raven.core.nvim-dap"
  --   end,
  -- }
  -- use {
  --   "rcarriga/nvim-dap-ui",
  --   after = "nvim-dap",
  --   config = function()
  --     require "raven.core.dapui"
  --   end,
  -- }

  -- editor plugins
  use "tpope/vim-sleuth"
  use {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    config = function()
      require "raven.core.nvim-tree"
    end,
    requires = { "nvim-tree/nvim-web-devicons" },
  }
  use {
    "numToStr/Comment.nvim",
    config = function()
      require "raven.editor.comment"
    end,
    requires = { "JoosepAlviste/nvim-ts-context-commentstring" },
  }
  use {
    "windwp/nvim-autopairs",
    after = "nvim-cmp",
    config = function()
      require "raven.editor.autopairs"
    end,
  }
  use {
    "lewis6991/gitsigns.nvim",
    event = "BufRead",
    config = function()
      require "raven.editor.gitsigns"
    end,
  }
  use {
    "akinsho/git-conflict.nvim",
    config = function()
      require("git-conflict").setup()
    end,
  }
  use {
    "RRethy/vim-illuminate",
    config = function()
      require("raven.editor.others").illuminate()
    end,
  }
  use {
    "akinsho/toggleterm.nvim",
    tag = "*",
    config = function()
      require "raven.editor.toggleterm"
    end,
  }
  use {
    "folke/which-key.nvim",
    keys = { "<leader>", "g", "z", '"', "'", "`" },
    config = function()
      require "raven.editor.whichkey"
    end,
  }

  -- ui plugins
  use {
    "nvim-lualine/lualine.nvim",
    config = function()
      require "raven.ui.lualine"
    end,
  }
  use {
    "akinsho/bufferline.nvim",
    tag = "v3.*",
    event = "BufWinEnter",
    config = function()
      require "raven.ui.bufferline"
    end,
    requires = { "moll/vim-bbye" },
  }
  use {
    "stevearc/dressing.nvim",
    config = function()
      require "raven.ui.dressing"
    end,
  }
  use {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    config = function()
      require "raven.ui.bqf"
    end,
  }

  -- colorschemes
  use "navarasu/onedark.nvim"

  -- run packer sync if packer is freshly installed
  if is_bootstrap then
    vim.cmd.highlight("NormalFloat", "guibg=none")
    packer.sync()
  end
end)

-- use {
--   "github/copilot.vim",
--   event = "InsertEnter",
--   cmd = "Copilot",
--   config = function()
--     require("raven.editor.others").copilot()
--   end,
-- }

-- use {
--   "kevinhwang91/nvim-ufo",
--   keys = { "z" },
--   config = function()
--     require "raven.editor.nvim-ufo"
--   end,
--   requires = { "kevinhwang91/promise-async", module = "promise" },
-- }
--
-- use {
--   "danymat/neogen",
--   module = "neogen",
--   config = function()
--     require("neogen").setup { snippet_engine = "luasnip" }
--   end,
-- }
--
-- use {
--   "michaelb/sniprun",
--   opt = true,
--   run = "bash ./install.sh",
-- }
--
--
-- use {
--   "sindrets/diffview.nvim",
--   opt = true,
--   config = function()
--     require("diffview").setup {}
--   end,
-- }

-- use {
--   "lukas-reineke/indent-blankline.nvim",
--   event = "BufWinEnter",
--   config = function()
--     require "raven.editor.indentline"
--   end,
-- }

-- use {
--   "sindrets/winshift.nvim",
--   opt = true,
-- }

-- use {
--   "Pocco81/true-zen.nvim",
--   cmd = { "TZAtaraxis", "TZMinimalist", "TZNarrow", "TZFocus" },
--   config = function()
--     require("true-zen").setup {}
--   end,
-- }

-- TODO: see why this doesn't close if not in git dir
-- use {
--   "goolord/alpha-nvim",
--   config = function()
--     require "raven.ui.alpha"
--   end,
-- }

-- use {
--   "rrethy/vim-hexokinase",
--   cmd = "HexokinaseToggle",
--   config = function()
--     require("raven.editor.others").hexokinase()
--   end,
--   run = "make hexokinase",
-- }

-- use {
--   "ggandor/leap.nvim",
--   keys = { "s", "S", "gs", "gS", "f", "F", "t", "T" },
--   config = function()
--     require("leap").set_default_keymaps()
--   end,
-- }

-- use {
--   "Shatur/neovim-session-manager",
--   config = function()
--     require("raven.editor.others").session()
--   end,
-- }

-- use {
--   "chipsenkbeil/distant.nvim",
--   opt = true,
--   config = function()
--     require("distant").setup {
--       ["*"] = require("distant.settings").chip_default(),
--     }
--   end,
-- }
