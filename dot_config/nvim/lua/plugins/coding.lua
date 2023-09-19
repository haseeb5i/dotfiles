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
          -- or C-p, C-n
          ["<C-k>"] = cmp.mapping.select_prev_item(),
          ["<C-j>"] = cmp.mapping.select_next_item(),
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
              -- vs-code like behavior cmp.confirm({ select = true })
              cmp.select_next_item()
              -- elseif luasnip.expand_or_jumpable() then
              --   luasnip.expand_or_jump()
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
          -- completion = cmp.config.window.bordered(),
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
  -- https://github.com/zbirenbaum/copilot.lua
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    opts = {
      suggestion = {
        auto_trigger = true,
      },
      panel = { enabled = false },
      filetypes = {
        help = false,
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
        toggler = {
          line = "gcc",
          block = "gbc",
        },
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
    opts = {
      mappings = {
        add = "gza", -- Add surrounding in Normal and Visual modes
        delete = "gzd", -- Delete surrounding
        find = "gzf", -- Find surrounding (to the right)
        find_left = "gzF", -- Find surrounding (to the left)
        highlight = "gzh", -- Highlight surrounding
        replace = "gzr", -- Replace surrounding
        update_n_lines = "gzn", -- Update `n_lines`
      },
    },
    keys = function(_, keys)
      -- Populate the keys based on the user's options
      local plugin = require("lazy.core.config").spec.plugins["mini.surround"]
      local opts = require("lazy.core.plugin").values(plugin, "opts", false)
      local mappings = {
        {
          opts.mappings.add,
          desc = "Add surrounding",
          mode = { "n", "v" },
        },
        { opts.mappings.delete, desc = "Delete surrounding" },
        { opts.mappings.find, desc = "Find right surrounding" },
        { opts.mappings.find_left, desc = "Find left surrounding" },
        { opts.mappings.highlight, desc = "Highlight surrounding" },
        { opts.mappings.replace, desc = "Replace surrounding" },
        { opts.mappings.update_n_lines, desc = "Update `MiniSurround.config.n_lines`" },
      }
      mappings = vim.tbl_filter(function(m)
        return m[1] and #m[1] > 0
      end, mappings)
      return vim.list_extend(mappings, keys)
    end,
  },
  {
    "danymat/neogen",
    enabled = false,
    opts = { snippet_engine = "luasnip" },
  },
  -- {'simrat39/symbols-outline.nvim', config = true}
  -- { "michaelb/sniprun", build = "bash ./install.sh" },
}
