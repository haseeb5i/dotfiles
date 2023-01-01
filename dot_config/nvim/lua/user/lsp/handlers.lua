local M = {}

M.setup = function()
  local signs = {
    Error = " ",
    Warn = " ",
    Hint = " ",
    Info = " ",
  }
  for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end

  vim.diagnostic.config {
    severity_sort = true,
    underline = true,
    virtual_text = false,
    float = {
      show_header = true,
      source = "always",
      border = "rounded",
      focusable = false,
    },
  }

  local function nmap(lhs, rhs, desc)
    vim.keymap.set("n", lhs, rhs, { desc = desc })
  end

  nmap("gl", vim.diagnostic.open_float, "View Diagnostic")
  nmap("]d", vim.diagnostic.goto_next, "Goto Next Diagnostic")
  nmap("[d", vim.diagnostic.goto_prev, "Goto Prev Diagnostic")
  nmap("]e", function()
    vim.diagnostic.goto_next { severity = vim.diagnostic.severity.ERROR }
  end, "Goto Next Error")
  nmap("[e", function()
    vim.diagnostic.goto_prev { severity = vim.diagnostic.severity.ERROR }
  end, "Goto Prev Error")
  nmap("<leader>ld", vim.diagnostic.setloclist, "Document Diagnostics")
  nmap("<leader>wd", vim.diagnostic.setqflist, "Workspace Diagnostics")

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
    relative = "cursor",
  })

  vim.lsp.handlers["textDocument/signatureHelp"] =
    vim.lsp.with(vim.lsp.handlers.signature_help, {
      border = "rounded",
      relative = "cursor",
      focusable = false,
    })
end

M.capabilities = require("cmp_nvim_lsp").default_capabilities()

M.on_attach = function(client, bufnr)
  local function map(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
  end

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

  -- add client specific maapings
  -- if client.name == "tsserver" then
  --   map("n", "", "<cmd>TypescriptOrganizeImports<cr>", "Organize Imports")
  --   map("n", "", "<cmd>TypescriptRenameFile<cr>", "Rename File")
  -- end

  -- for now disabling this for all servers, should be per client
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false
end

-- set handlers per server?
-- M.handlers = {
--   ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
--     border = "rounded",
--     relative = "cursor",
--   }),
-- }
return M
