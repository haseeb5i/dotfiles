return {
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPost",
    cond = function()
      vim.fn.system("git -C " .. vim.fn.expand "%:p:h" .. " rev-parse")
      return vim.v.shell_error == 0
    end,
    opts = {

      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "契" },
        topdelete = { text = "契" },
      },
      preview_config = { border = "rounded" },
    },
  },
  {
    "sindrets/diffview.nvim",
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewToggleFiles",
      "DiffviewFocusFiles",
    },
    config = true,
  },
  { "akinsho/git-conflict.nvim", config = true },
}
