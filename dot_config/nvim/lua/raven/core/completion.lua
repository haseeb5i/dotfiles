local present, cmp = pcall(require, "cmp")
if not present then
  return
end

local luasnip = require "luasnip"
local kind_icons = require("raven.ui.icons").lspkind

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

cmp.setup.cmdline("/", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "buffer" },
  },
})

cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "cmdline" },
  },
})
