local M = {
  "stevearc/dressing.nvim",
  event = "VeryLazy",
}

M.opts = {
  select = {
    backend = { "builtin" },
    builtin = {
      win_options = {
        winblend = 0,
      },
    },
    get_config = function(opts)
      if opts.kind == "codeaction" then
        return {
          builtin = {
            relative = "cursor",
            min_height = 0,
          },
        }
      end
    end,
  },
}

return M
