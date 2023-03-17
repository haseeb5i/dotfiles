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
    keys = {
      -- stylua: ignore start
      { "<leader>gj", "<cmd>lua require'gitsigns'.next_hunk()<cr>",       desc = "Next Hunk", },
      { "<leader>gk", "<cmd>lua require'gitsigns'.prev_hunk()<cr>",       desc = "Prev Hunk", },
      { "<leader>gl", "<cmd>lua require'gitsigns'.blame_line()<cr>",      desc = "Blame" },
      { "<leader>gp", "<cmd>lua require'gitsigns'.preview_hunk()<cr>",    desc = "Preview Hunk", },
      { "<leader>gr", "<cmd>lua require'gitsigns'.reset_hunk()<cr>",      desc = "Reset Hunk", },
      { "<leader>gR", "<cmd>lua require'gitsigns'.reset_buffer()<cr>",    desc = "Reset Buffer", },
      { "<leader>gs", "<cmd>lua require'gitsigns'.stage_hunk()<cr>",      desc = "Stage Hunk", },
      { "<leader>gu", "<cmd>lua require'gitsigns'.undo_stage_hunk()<cr>", desc = "Undo Stage Hunk", },
      { "<leader>gd", "<cmd>Gitsigns diffthis HEAD<cr>",                  desc = "Open Diff", },
      -- stylua: ignore end
    },
  },
  {
    "sindrets/diffview.nvim",
    enabled = false,
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewToggleFiles",
      "DiffviewFocusFiles",
    },
    config = true,
    -- keys = {
    --   { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "DiffView" },
    -- },
  },
  {
    "akinsho/git-conflict.nvim",
    config = true,
    enabled = false,
  },
}
