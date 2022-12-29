local M = {
  "hrsh7th/nvim-cmp",
  event = { "CmdlineEnter", "InsertEnter" },
  dependencies = {
    "L3MON4D3/LuaSnip",
    "rafamadriz/friendly-snippets",
    "saadparwaiz1/cmp_luasnip",

    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-nvim-lua",
  },
}

function M.config()
  local kind_icons = require("user.icons").lspkind
  local cmp = require "cmp"
  local luasnip = require "luasnip"

  require("luasnip.loaders.from_vscode").lazy_load()

  cmp.setup {
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert {
      ["<C-j>"] = cmp.mapping.select_next_item(),
      ["<C-k>"] = cmp.mapping.select_prev_item(),
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-c>"] = cmp.mapping.abort(),
      ["<CR>"] = cmp.mapping.confirm {
        select = false,
      },
      -- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#luasnip
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
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
      format = function(_, vim_item)
        vim_item.kind = kind_icons[vim_item.kind] .. vim_item.kind
        local maxwidth = 45
        local label = vim_item.abbr
        if #label > maxwidth then
          vim_item.abbr = string.sub(label, 1, maxwidth) .. "..."
        end
        return vim_item
      end,
    },
    -- sources = {
    --   { name = "nvim_lsp" },
    --   { name = "luasnip" },
    --   { name = "buffer" },
    --   { name = "path" },
    -- },
    sources = cmp.config.sources({
      { name = "nvim_lsp" },
      { name = "luasnip" },
    }, {
      { name = "buffer" },
      { name = "path" },
      { name = "nvim_lua" },
    }),
    window = {
      completion = cmp.config.window.bordered(),
      documentation = {
        border = "rounded",
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

  cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = "path" },
      { name = "cmdline" },
    },
  })
end

return M
