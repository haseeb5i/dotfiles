return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      {
        "Exafunction/codeium.nvim",
        cmd = "Codeium",
        build = ":Codeium Auth",
        opts = {},
      },
    },
    opts = function(_, opts)
      local cmp = require("cmp")

      opts.auto_brackets = {}
      opts.experimental = {
        ghost_text = false,
      }

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
        ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
      })

      table.insert(opts.sources, 1, { name = "codeium" })
    end,
  },
}
