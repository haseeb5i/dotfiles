return {
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      local cmp = require("cmp")
      local icons = require("lazyvim.config").icons.kinds

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
        ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
      })

      opts.formatting = {
        format = function(_, item)
          item.kind = icons[item.kind] .. item.kind
          local maxwidth = 45
          local label = item.abbr
          if #label > 45 then
            item.abbr = string.sub(label, 1, maxwidth) .. "..."
          end
          return item
        end,
      }

      opts.experimental = {
        ghost_text = false,
      }

      cmp.event:on("menu_opened", function()
        ---@diagnostic disable-next-line: inject-field
        vim.b.copilot_suggestion_hidden = true
      end)

      cmp.event:on("menu_closed", function()
        ---@diagnostic disable-next-line: inject-field
        vim.b.copilot_suggestion_hidden = false
      end)
    end,
  },
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    opts = {
      panel = { enabled = false },
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          -- accept = "<Tab>",
          accept = "<M-l>",
          -- TODO: Add a keymap to accept the suggestion
          accept_word = false,
          accept_line = false,
        },
      },
      filetypes = {
        markdown = false,
        help = false,
      },
    },
  },
  {
    -- NOTE: using beacuse we can't remap mini.comment
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    opts = function()
      local ctx_commentstring = require("ts_context_commentstring.integrations.comment_nvim")
      return {
        ignore = "^$",
        mappings = {
          extra = false,
        },
        pre_hook = ctx_commentstring.create_pre_hook(),
      }
    end,
  },
}
