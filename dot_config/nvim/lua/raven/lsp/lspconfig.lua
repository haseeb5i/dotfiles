local lspconfig = require "lspconfig"
local server_opts = require "raven.lsp.providers"

require "raven.lsp.mason"
require "raven.ui.lsp"

vim.keymap.set("n", "gl", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", vim.diagnostic.goto_next)
vim.keymap.set("n", "]d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "<leader>lq", vim.diagnostic.setloclist)

local function on_attach(client, bufnr)
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false

  require("raven.lsp.handlers").set_lsp_keymaps(bufnr)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

local servers = {
  "tsserver",
  "html",
  "cssls",
  "jsonls",
  "graphql",
  "rust_analyzer",
  "pyright",
  "sumneko_lua",
}

-- :help lspconfig-setup
for _, lsp in ipairs(servers) do
  local opts = vim.tbl_extend("force", server_opts[lsp] or {}, {
    on_attach = on_attach,
    capabilities = capabilities,
  })

  lspconfig[lsp].setup(opts)
end

vim.api.nvim_create_augroup("_lsp_metals", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "scala", "sbt", "java" },
  callback = require("raven.lsp.metals").setup,
  group = "_lsp_metals",
})
