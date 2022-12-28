local M = {}

function M.setup_lsp_ui()
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
      vim.api.nvim_echo({ { msg } }, true)
    end
  end

  -- add border to lspinfo window
  require("lspconfig.ui.windows").default_options.border = "rounded"
end

function M.set_lsp_keymaps(bufnr)
  local function imap(lhs, rhs, desc)
    vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
  end

  local function nmap(lhs, rhs, desc)
    vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
  end

  nmap("gd", vim.lsp.buf.definition, "Goto Definition")
  nmap("gD", vim.lsp.buf.declaration, "Goto Declaration")
  nmap("gi", vim.lsp.buf.implementation, "Got Implementation")
  nmap("gr", vim.lsp.buf.references, "Goto References")
  nmap("K", vim.lsp.buf.hover, "Hover Documentation")
  imap("<C-k>", vim.lsp.buf.signature_help, "Signature Help")
  nmap("<leader>lr", vim.lsp.buf.rename, "LSP Rename")
  nmap("<leader>la", vim.lsp.buf.code_action, "Code Action")
  nmap("<leader>lD", vim.lsp.buf.type_definition, "Type Definition")
  nmap("<leader>lf", function()
    vim.lsp.buf.format { async = true }
  end, "Format Document")
  nmap("<leader>wa", vim.lsp.buf.add_workspace_folder)
  nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder)
  nmap("<leader>wl", vim.lsp.buf.list_workspace_folders)
  nmap("<leader>wd", vim.lsp.buf.document_symbol)
  nmap("<leader>ws", vim.lsp.buf.workspace_symbol)
end

return M
