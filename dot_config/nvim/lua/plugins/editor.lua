return {
  { "tpope/vim-sleuth", event = "BufReadPre" }, -- maybe use builtin editorconfig
  { "ThePrimeagen/vim-be-good", cmd = "VimBeGood" },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      close_if_last_window = true,
      default_component_configs = {
        git_status = {
          symbols = { ignored = "", unstaged = "" },
        },
      },
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
        width = 34,
        mappings = {
          ["o"] = "open",
          ["l"] = "open",
          ["h"] = "close_node",
        },
      },
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      {
        "<leader><space>",
        "<cmd>Telescope find_files theme=dropdown previewer=false<cr>",
        desc = "Find Files (root dir)",
      },
    },
    opts = function(_, opts)
      local actions = require("telescope.actions")

      opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
        mappings = {
          i = {
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
            ["<C-p>"] = require("telescope.actions.layout").toggle_preview,
            ["<esc>"] = actions.close,
          },
          n = {
            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
          },
        },
      })

      opts.pickers = {
        buffers = {
          theme = "dropdown",
          previewer = false,
        },
      }
    end,
  },
  {
    "sindrets/diffview.nvim",
    cmd = {
      "DiffviewOpen",
      "DiffviewFileHistory",
    },
    opts = {},
  },
}
