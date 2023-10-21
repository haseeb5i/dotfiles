return {
  {
    "L3MON4D3/LuaSnip",
    -- stylua: ignore
    keys = function() return {} end,
  },
  {
    "hrsh7th/nvim-cmp",
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local cmp, luasnip = require("cmp"), require("luasnip")
      local kind_icons = require("lazyvim.config").icons.kinds

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<C-k>"] = cmp.mapping.select_prev_item(),
        ["<C-j>"] = cmp.mapping.select_next_item(),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.confirm({ select = true })
            -- luasnip.expand_or_locally_jumpable()
          elseif luasnip.jumpable(1) then
            luasnip.jump(1)
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
        fields = { "kind", "abbr", "menu" },
        format = function(_, item)
          item.kind = string.format("%s", kind_icons[item.kind])
          local maxwidth = 45
          local label = item.abbr
          if #label > maxwidth then
            item.abbr = string.sub(label, 1, maxwidth) .. "..."
          end
          -- item.menu = entry.source.name
          return item
        end,
      })
    end,
  },
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    opts = function()
      local ctx_commentstring =
        require("ts_context_commentstring.integrations.comment_nvim")
      return {
        ignore = "^$",
        mappings = {
          extra = false,
          pre_hook = ctx_commentstring.create_pre_hook(),
        },
      }
    end,
  },
}
