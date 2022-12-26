local M = {}

function M.set_lsp_keymaps(bufnr)
  local function nmap(lhs, rhs, desc)
    vim.keymap.set("n", lhs, rhs, { desc = desc, buffer = bufnr })
  end

  nmap("gd", vim.lsp.buf.definition, "Goto Definition")
  nmap("gD", vim.lsp.buf.declaration, "Goto Declaration")
  nmap("gi", vim.lsp.buf.implementation, "Got Implementation")
  nmap("K", vim.lsp.buf.hover, "Hover Documentation")
  nmap("gr", vim.lsp.buf.references, "Goto References")
  nmap("<leader>lr", vim.lsp.buf.rename, "LSP Rename")
  nmap("<leader>la", vim.lsp.buf.code_action, "Code Action")
  nmap("<leader>lD", vim.lsp.buf.type_definition, "Type Definition")
  nmap("<leader>lf", function()
    vim.lsp.buf.format { async = true }
  end, "Format Document")
  nmap("<leader>wa", vim.lsp.buf.add_workspace_folder)
  nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder)
  nmap("<leader>wl", vim.lsp.buf.list_workspace_folders)
  -- nmap("<leader>ws", vim.lsp.buf.document_symbol)
  nmap("<leader>ws", vim.lsp.buf.workspace_symbol)
  vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, { buffer = bufnr })
end

return M
