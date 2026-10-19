return {
  { "tpope/vim-sleuth", event = "BufReadPre" }, -- maybe use builtin editorconfig
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      code = {
        sign = false,
        width = "block",
        right_pad = 1,
      },
      heading = {
        icons = {},
      },
      checkbox = {
        enabled = false,
      },
    },
    ft = { "markdown", "norg", "rmd", "org", "codecompanion" },
    config = function(_, opts)
      require("render-markdown").setup(opts)
      Snacks.toggle({
        name = "Render Markdown",
        get = require("render-markdown").get,
        set = require("render-markdown").set,
      }):map("<leader>um")
    end,
  },
  {
    "snacks.nvim",
    ---@module 'snacks'
    ---@type snacks.Config
    opts = {
      scroll = { enabled = false },
      picker = {
        sources = {
          explorer = {
            hidden = true,
            ignored = true,
            exclude = { ".git", "node_modules" },
            win = {
              input = {
                keys = {
                  ["<Esc>"] = { "toggle_focus", mode = { "n", "i" } },
                },
              },
            },
          },
          files = {
            hidden = true,
            exclude = { ".git", "node_modules" },
          },
          grep = {
            hidden = true,
            exclude = { ".git", "node_modules" },
          },
        },
        win = {
          input = {
            keys = {
              ["<Esc>"] = { "close", mode = { "n", "i" } },
            },
          },
        },
      },
    },
  },
}
