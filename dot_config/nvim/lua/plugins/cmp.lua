return {
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter", -- CmdlineEnter
    version = false,
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      --   "hrsh7th/cmp-cmdline",
    },
    config = function()
      local cmp, luasnip = require "cmp", require "luasnip"
      local kind_icons = require("user.icons").lspkind

      local function has_words_before()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        if col ~= 0 then
          local line_text = vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]
          return line_text:sub(col, col):match "%s"
        end
        return nil
      end

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        -- preselect = cmp.PreselectMode.None,
        -- confirm_opts = {
        --   behavior = cmp.ConfirmBehavior.Replace,
        --   select = false,
        -- },
        mapping = cmp.mapping.preset.insert {
          ["<Up>"] = cmp.mapping.select_prev_item(),
          ["<Down>"] = cmp.mapping.select_next_item(),
          ["<C-k>"] = cmp.mapping.select_prev_item(),
          ["<C-j>"] = cmp.mapping.select_next_item(),
          ["<C-u>"] = cmp.mapping.scroll_docs(-4),
          ["<C-d>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          -- ["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
          -- ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
          -- ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
          ["<C-y>"] = cmp.config.disable,
          ["<C-e>"] = cmp.mapping { i = cmp.mapping.abort(), c = cmp.mapping.close() },
          ["<CR>"] = cmp.mapping.confirm { select = true },
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
              -- disabling expand on <Tab> for luasnip
              -- elseif luasnip.expand_or_jumpable() then
              -- luasnip.expand_or_jump()
            elseif luasnip.jumpable(1) then
              luasnip.jump(1)
            elseif has_words_before() then
              cmp.complete()
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
    end,
  },
}
