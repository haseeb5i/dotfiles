return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false, -- using latest version
    build = ":TSUpdate",
    -- event = "BufRead", -- not triggered on empty buffer
    event = { "BufReadPost", "BufNewFile" },
    cmd = "TSUpdateSync",
    opts = {
      highlight = { enable = true },
      indent = { enable = true },
      incremental_selection = { enable = true },
      ensure_installed = {
        "bash",
        "css",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "python",
        "scala",
        "tsx",
        "typescript",
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
        lsp_interop = {
          enable = true,
          border = "rounded",
          peek_definition_code = {
            ["<leader>df"] = "@function.outer",
            ["<leader>dF"] = "@class.outer",
          },
        },
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
  },
  { "windwp/nvim-ts-autotag", event = "InsertEnter" },
  {
    -- NOTE: this loads ts if not loaded on 'BufRead' event
    "nvim-treesitter/nvim-treesitter-textobjects",
    event = "VeryLazy",
  },
  {
    "nvim-treesitter/playground",
    cmd = { "TSPlaygroundToggle", "TSCaptureUnderCursor" },
  },
}
