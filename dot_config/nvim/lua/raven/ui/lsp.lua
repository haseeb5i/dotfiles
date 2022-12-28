-- https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
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
