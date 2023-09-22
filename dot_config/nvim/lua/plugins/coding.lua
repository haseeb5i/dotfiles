return {
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
    opts = {
      history = true,
      delete_check_events = "TextChanged",
    },
  },
  {
    "hrsh7th/nvim-cmp",
    version = false, -- using latest version
    event = "InsertEnter", -- CmdlineEnter
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
      -- "hrsh7th/cmp-cmdline",
    },
    config = function()
      vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })

      local cmp, luasnip = require "cmp", require "luasnip"
      local kind_icons = require("user.icons").lspkind

      cmp.setup {
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert {
          ["<C-k>"] = cmp.mapping.select_prev_item(), -- C-p
          ["<C-j>"] = cmp.mapping.select_next_item(), -- C-n
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-y>"] = cmp.config.disable,
          ["<C-e>"] = cmp.mapping {
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
          },
          ["<CR>"] = cmp.mapping.confirm { select = true },
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.confirm { select = true }
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
        },
        formatting = {
          fields = { "abbr", "kind", "menu" },
          format = function(_, vim_item)
            vim_item.kind = kind_icons[vim_item.kind] .. vim_item.kind
            local maxwidth = 42
            local label = vim_item.abbr
            if #label > maxwidth then
              vim_item.abbr = string.sub(label, 1, maxwidth) .. "..."
            end
            return vim_item
          end,
          experimental = {
            ghost_text = {
              hl_group = "CmpGhostText",
            },
          },
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
          { name = "path" },
        }),
        window = {
          completion = {
            border = "single",
          },
          documentation = {
            border = "single",
            max_width = 50,
          },
        },
      }

      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      --   cmp.setup.cmdline(":", {
      --     mapping = cmp.mapping.preset.cmdline(),
      --     sources = {
      --       { name = "cmdline" },
      --       { name = "path" },
      --     },
      --   })

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
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      suggestion = {
        auto_trigger = true,
        keymaps = {
          accept_word = false,
        },
      },
      panel = { enabled = false },
      filetypes = {
        markdown = false,
      },
    },
  },
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    opts = function()
      local integration = require "ts_context_commentstring.integrations.comment_nvim"

      return {
        ignore = "^$",
        pre_hook = integration.create_pre_hook(),
      }
    end,
    keys = {
      {
        vim.g.neovide and "<C-/>" or "<C-_>",
        function()
          return vim.v.count == 0 and "<Plug>(comment_toggle_linewise_current)"
            or "<Plug>(comment_toggle_linewise_count)"
        end,
        expr = true,
      },
      {
        vim.g.neovide and "<C-/>" or "<C-_>",
        "<Plug>(comment_toggle_linewise_visual)",
        mode = "v",
      },
    },
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      check_ts = true,
      ts_config = {
        lua = { "string" },
      },
      fast_wrap = {
        map = "<M-e>",
        highlight = "PmenuSel",
      },
    },
    config = function(_, opts)
      require("nvim-autopairs").setup(opts)

      local ts_utils = require "nvim-treesitter.ts_utils"
      local cmp_autopairs = require "nvim-autopairs.completion.cmp"

      require("cmp").event:on("confirm_done", function(evt)
        local tsnode = ts_utils.get_node_at_cursor()
        if not tsnode or tsnode:type() ~= "named_imports" then
          cmp_autopairs.on_confirm_done()(evt)
        end
      end)
    end,
  },
  {
    "echasnovski/mini.surround",
    event = "VeryLazy",
    opts = {
      mappings = {
        add = "gza",
        delete = "gzd",
        find = "gzf",
        find_left = "gzF",
        highlight = "gzh",
        replace = "gzr",
        update_n_lines = "gzn",
      },
    },
  },
  {
    "danymat/neogen",
    enabled = false,
    opts = { snippet_engine = "luasnip" },
  },
  -- {'simrat39/symbols-outline.nvim', config = true}
}
