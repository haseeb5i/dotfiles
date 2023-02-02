local M = {
  "nvim-treesitter/nvim-treesitter",
  version = false, -- using latest version
  build = ":TSUpdate",
  event = "BufRead",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  opts = {
    highlight = { enable = true },
    indent = { enable = true },
    ensure_installed = {
      "css",
      "help",
      "html",
      "javascript",
      "json",
      "python",
      "scala",
      "tsx",
      "typescript",
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<c-space>",
        node_incremental = "<c-space>",
        node_decremental = "<c-backspace>",
        scope_incremental = "<c-s>",
      },
    },
    -- for windwp/nvim-ts-autotag
    autotag = { enable = true },
    -- for JoosepAlviste/nvim-ts-context-commentstring
    context_commentstring = {
      enable = true,
      enable_autocmd = false,
    },
    -- for nvim-treesitter/nvim-treesitter-textobjects
    textobjects = {
      move = { enable = true },
      select = {
        enable = true,
        keymaps = {
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
        },
      },
      swap = { enable = false },
    },
    -- for nvim-treesitter/playground
    playground = {
      enable = true,
      disable = {},
      updatetime = 25,
    },
  },
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)
  end,
}

return M
