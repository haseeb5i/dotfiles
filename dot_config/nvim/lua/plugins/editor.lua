return {
  { "tpope/vim-sleuth", event = "BufReadPre" }, -- maybe use builtin editorconfig
  { "ThePrimeagen/vim-be-good", cmd = "VimBeGood" },
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
            win = {
              input = {
                keys = {
                  ["<Esc>"] = { "toggle_focus", mode = { "n", "i" } },
                },
              },
            },
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
