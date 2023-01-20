local M = {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = "BufRead",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
}

M.config = function()

  require("nvim-treesitter.configs").setup {
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
    highlight = { enable = true },
    indent = {
      enable = true,
      disable = { "yaml", "python" },
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
    sync_install = false,
    -- for windwp/nvim-ts-autotag
    autotag = { enable = true },
    -- for JoosepAlviste/nvim-ts-context-commentstring
    context_commentstring = {
      enable = true,
      enable_autocmd = false,
    },
    -- for nvim-treesitter/nvim-treesitter-textobjects
    textobjects = {
      move = {
        enable = true,
      },
      select = {
        enable = true,
        keymaps = {
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
        },
      },
      swap = {
        enable = false,
      },
    },
    -- for nvim-treesitter/playground
    playground = {
      enable = true,
      disable = {},
      updatetime = 25,
    },
  }
end

return M
