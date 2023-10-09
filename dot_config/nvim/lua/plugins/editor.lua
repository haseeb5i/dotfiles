return {
  { "tpope/vim-sleuth", event = "BufReadPre" },
  { "ThePrimeagen/vim-be-good", cmd = "VimBeGood" },
  { "windwp/nvim-ts-autotag", event = "InsertEnter" },
  {
    "telescope.nvim",
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      config = function()
        require("telescope").load_extension("fzf")
      end,
    },
    -- opts = {
    --   pickers = {
    --     find_files = { hidden = false },
    --     live_grep = {
    --       glob_pattern = "!**/.git/*",
    --       additional_args = { "--hidden" },
    --     },
    --     grep_string = {},
    --   },
    -- },
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
}
