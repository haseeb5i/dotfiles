local M = {}

function M.setup_diagnostics()
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

  vim.keymap.set("n", "gl", vim.diagnostic.open_float)
  vim.keymap.set("n", "[d", vim.diagnostic.goto_next)
  vim.keymap.set("n", "]d", vim.diagnostic.goto_prev)
  vim.keymap.set("n", "<leader>lq", vim.diagnostic.setloclist)
end

function M.setup_handlers()
	-- add round border to float windows
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
    vim.lsp.handlers.hover, {
    border = "rounded",
    relative = "cursor",
  })

  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
    vim.lsp.handlers.signature_help, {
      border = "rounded",
      relative = "cursor",
      focusable = false,
    })

  -- suppress error messages from lang servers
  vim.notify = function(msg, level)
    if msg:match "exit code" then
      return
    end
    if level == vim.log.levels.ERROR then
      vim.api.nvim_err_writeln(msg)
    else
      vim.api.nvim_echo({ { msg } }, true, {})
    end
  end

end

function M.setup_keymaps(bufnr)
  local function map(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
  end

  -- add client specific maapings
-- client.name == "tsserver",

  map("n", "gd", vim.lsp.buf.definition, "Goto Definition")
  map("n", "gD", vim.lsp.buf.declaration, "Goto Declaration")
  map("n", "gi", vim.lsp.buf.implementation, "Got Implementation")
  map("n", "gr", vim.lsp.buf.references, "Goto References")
  map("n", "K", vim.lsp.buf.hover, "Hover Documentation")
  map("i", "<C-k>", vim.lsp.buf.signature_help, "Signature Help")
  map("n", "<leader>lr", vim.lsp.buf.rename, "LSP Rename")
  map("n", "<leader>la", vim.lsp.buf.code_action, "Code Action")
  map("n", "<leader>lD", vim.lsp.buf.type_definition, "Type Definition")
  map("n", "<leader>lf", function()
    vim.lsp.buf.format { async = true }
  end, "Format Document")
  map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder)
  map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder)
  map("n", "<leader>wl", vim.lsp.buf.list_workspace_folders)
  map("n", "<leader>wd", vim.lsp.buf.document_symbol)
  map("n", "<leader>ws", vim.lsp.buf.workspace_symbol)
end



return M
