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
        delete = { text = "契" },
        topdelete = { text = "契" },
        add = { text = "▎" },
        change = { text = "▎" },
      },
      preview_config = { border = "rounded" },
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
