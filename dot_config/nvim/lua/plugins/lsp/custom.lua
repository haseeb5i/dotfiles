local M = {}

-- disable lsp formatting for these
local format_blacklist = {
  graphql = true,
  pyright = true,
  tsserver = true,
  lua_ls = true,
}

M.on_attach = function(client, bufnr)
  local function map(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
  end

  -- TODO: bring diagnostic keymaps here too
  map("n", "gd", vim.lsp.buf.definition, "Goto Definition")
  map("n", "gD", vim.lsp.buf.declaration, "Goto Declaration")
  map("n", "gi", vim.lsp.buf.implementation, "Got Implementation")
  map("n", "gr", vim.lsp.buf.references, "Goto References")
  map("n", "K", vim.lsp.buf.hover, "Hover Documentation")
  map("i", "<C-k>", vim.lsp.buf.signature_help, "Signature Help")
  map("n", "<leader>lf", function()
    vim.lsp.buf.format { async = true }
  end, "Format Document")
  map("n", "<leader>lr", vim.lsp.buf.rename, "LSP Rename")
  map("n", "<leader>la", vim.lsp.buf.code_action, "Code Action")
  map("n", "<leader>lD", vim.lsp.buf.type_definition, "Type Definition")
  map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder)
  map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder)
  map("n", "<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end)
  map("n", "<leader>ls", "<cmd>Telescope lsp_document_symbol<cr>")
  map("n", "<leader>ws", "<cmd>Telescope lsp_workspace_symbol<cr>")

  if client.name == "tsserver" then
    map("n", "<leader>co", "<cmd>TypescriptOrganizeImports<cr>", "Organize Imports")
    map("n", "<leader>cR", "<cmd>TypescriptRenameFile<cr>", "Rename File")
  end

  if format_blacklist[client.name] then
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end
  require("nvim-navic").attach(client, bufnr)
end

M.capabilities = require("cmp_nvim_lsp").default_capabilities()
-- as long as neovim don't include this by default
M.capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}

-- TODO: handle this globally
M.handlers = {
  ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
    relative = "cursor",
  }),
  ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
    relative = "cursor",
    focusable = false,
  }),
}

return M
