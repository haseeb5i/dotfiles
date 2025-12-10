return {
  { "tpope/vim-sleuth", event = "BufReadPre" }, -- maybe use builtin editorconfig
  { "ThePrimeagen/vim-be-good", cmd = "VimBeGood" },
  -- {
  --   "m4xshen/hardtime.nvim",
  --   lazy = false,
  --   dependencies = { "MunifTanjim/nui.nvim" },
  --   opts = {},
  -- },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      close_if_last_window = true,
      filesystem = {
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          never_show = { ".git" },
        },
        group_empty_dirs = true,
      },
      source_selector = { winbar = true },
      window = {
        mappings = {
          ["o"] = "open",
        },
        width = 34,
      },
      default_component_configs = {
        git_status = {
          symbols = { ignored = "", unstaged = "" },
        },
      },
    },
  },
  -- {
  --   "ibhagwan/fzf-lua",
  --   opts = function(_, opts) end,
  -- },
}
