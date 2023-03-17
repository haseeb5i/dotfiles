return {
  { "nvim-lua/plenary.nvim" },
  { "tpope/vim-sleuth", event = "BufReadPre" },
  { "famiu/bufdelete.nvim", cmd = { "Bdelete", "Bwipeout" } },
  {
    "nvim-tree/nvim-web-devicons",
    opts = { override = require("user.icons").devicons },
  },
  {
    "Shatur/neovim-session-manager",
    event = "BufWritePost",
    cmd = "SessionManager",
    opts = function()
      local session_conf = require "session_manager.config"
      return {
        autoload_mode = session_conf.AutoloadMode.Disabled,
        autosave_last_session = true,
        autosave_ignore_dirs = {
          vim.env.HOME,
        },
        autosave_ignore_filetypes = {
          "alpha",
          "neo-tree",
          "gitcommit",
        },
      }
    end,
    keys = {
      { "<leader>r", "<cmd> SessionManager load_session<cr>", desc = "Load Session" },
    },
  },
  -- {
  --   "github/copilot.vim",
  --   event = "VeryLazy",
  --   config = function()
  --     vim.g.copilot_filetypes = {
  --       ["*"] = false,
  --       python = true,
  --       lua = true,
  --       typescript = true,
  --       typescriptreact = true,
  --     }

  --     vim.cmd [[ imap <silent><script><expr> <C-l> copilot#Accept("\<CR>") ]]
  --     vim.g.copilot_no_tab_map = true
  --   end,
  -- },
  -- {
  --   "danymat/neogen",
  --   enabled = false,
  --   opts = { snippet_engine = "luasnip" },
  --   keys = {
  --     {
  --       "<leader>cf",
  --       "<cmd>lua require'neogen'.generate{type = 'func'}<cr>",
  --       desc = "Function Annotation",
  --     },
  --     {
  --       "<leader>cc",
  --       "<cmd>lua require'neogen'.generate{type = 'class'}<cr>",
  --       desc = "Class Annotation",
  --     },
  --     {
  --       "<leader>ct",
  --       "<cmd>lua require'neogen'.generate{type = 'type'}<cr>",
  --       desc = "Type Annotation",
  --     },
  --     {
  --       "<leader>cF",
  --       "<cmd>lua require'neogen'.generate{type = 'file'}<cr>",
  --       desc = "File Annotation",
  --     },
  --   },
  -- },
  -- { "michaelb/sniprun", build = "bash ./install.sh" },
  -- { "sindrets/winshift.nvim", enabled = false },
  -- { "NMAC427/guess-indent.nvim", config = require "plugins.configs.guess-indent" },
  -- {
  --   "max397574/better-escape.nvim",
  --   event = "InsertCharPre",
  --   opts = { timeout = 300 },
  -- },
  -- { "s1n7ax/nvim-window-picker", opts = { use_winbar = "smart" } },
  -- {
  --   "mrjones2014/smart-splits.nvim",
  --   opts = {
  --     ignored_filetypes = { "nofile", "quickfix", "qf", "prompt" },
  --     ignored_buftypes = { "nofile" },
  --   },
  -- },
}
