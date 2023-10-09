return {
  {
    "L3MON4D3/LuaSnip",
    keys = function() return {} end,
  },
  {
    "hrsh7th/nvim-cmp",
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local cmp, luasnip = require("cmp"), require("luasnip")

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.confirm({ select = true })
          elseif luasnip.jumpable() then
            luasnip.jump()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      })

      opts.formatting = vim.tbl_extend("force", opts.formatting, {
        fields = { "abbr", "kind", "menu" },
        format = function(_, item)
          local kind_icons = require("lazyvim.config").icons.kinds
          item.kind = kind_icons[item.kind] .. item.kind
          local maxwidth = 42
          local label = item.abbr
          if #label > maxwidth then
            item.abbr = string.sub(label, 1, maxwidth) .. "..."
          end
          return item
        end,
      })

    end,
  },
  {
    "zbirenbaum/copilot.lua",
    opts = {
      filetypes = {
        markdown = false,
      },
    },
  },
  {
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
    keys = {
      { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" },
    },
    config = true,
  },
}
