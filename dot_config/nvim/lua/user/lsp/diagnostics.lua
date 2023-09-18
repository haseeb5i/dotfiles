local M = {}

M.setup = function()
  local signs = require("user.icons").diagnostics

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
end

return M
