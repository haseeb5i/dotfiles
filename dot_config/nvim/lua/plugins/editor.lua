return {
  { "tpope/vim-sleuth", event = "BufReadPre" }, -- maybe use builtin editorconfig
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      {
        "<leader>/",
        "<cmd>Telescope find_files theme=dropdown previewer=false<cr>",
        desc = "Find Files",
      },
--   {
--     "<leader>b",
--     "<cmd> Telescope buffers theme=dropdown previewer=false <cr>",
--     desc = "Find Buffers",
--   },
    },
    opts = function(_, opts)
      local actions = require("telescope.actions")
      opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
        mappings = {
          i = {
            ["<esc>"] = actions.close,
          },
        },
      })
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      close_if_last_window = true,
      hide_root_node = false,
      filesystem = {
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          never_show = { ".git" },
        },
        group_empty_dirs = true,
      },
      source_selector = {
        winbar = false,
      },
      window = {
        mappings = {
          ["o"] = "open",
          ["l"] = "open",
          ["h"] = "close_node",
        },
        width = 34,
      },
    },
  },
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    config = true,
  },
  {
    "sindrets/diffview.nvim",
    cmd = {
      "DiffviewOpen",
      "DiffviewFileHistory",
    },
    config = true,
  },
  {
    "akinsho/git-conflict.nvim",
    config = true,
    enabled = false,
  },
  { "ThePrimeagen/vim-be-good", cmd = "VimBeGood" },
}
