---@diagnostic disable: inject-field
return {
  {
    "L3MON4D3/LuaSnip",
    -- stylua: ignore
    keys = function() return {} end,
  },
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      local cmp, luasnip = require("cmp"), require("luasnip")
      local kind_icons = require("lazyvim.config").icons.kinds

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
        ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })
          elseif luasnip.jumpable(1) then
            luasnip.jump(1)
          else
            -- TODO: if copilot has suggestion, accept
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

      opts.formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(_, item)
          item.menu = string.format("[%s]", item.kind)
          item.kind = string.format("%s", kind_icons[item.kind])
          local maxwidth = 45
          local label = item.abbr
          if #label > maxwidth then
            item.abbr = string.sub(label, 1, maxwidth) .. "..."
          end
          return item
        end,
      }

      opts.experimental = {
        ghost_text = false,
      }

      cmp.event:on("menu_opened", function()
        vim.b.copilot_suggestion_hidden = true
      end)

      cmp.event:on("menu_closed", function()
        vim.b.copilot_suggestion_hidden = false
      end)
    end,
  },
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = "<M-l>",
          -- TODO: Add a keymap to accept the suggestion
          accept_word = false,
          accept_line = false,
        },
      },
    },
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
