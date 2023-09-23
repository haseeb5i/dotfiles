local M = {}

M.lua_ls = {
  settings = {
    Lua = {
      completion = {
        callSnippet = "Replace",
      },
      workspace = {
        checkThirdParty = false,
      },
      telemetry = { enable = false },
    },
  },
}

M.jsonls = {
  settings = {
    json = {
      schemas = require("schemastore").json.schemas(),
      validate = { enable = true },
    },
  },
}

M.pyright = {
  settings = {
    python = {
      analysis = {
        diagnosticMode = "workspace",
        typeCheckingMode = "basic",
        useLibraryCodeForTypes = true,
      },
    },
  },
}

M.tsserver = {
  keys = {
    { "<leader>co", "<cmd>TypescriptOrganizeImports<CR>", desc = "Organize Imports" },
    { "<leader>cR", "<cmd>TypescriptRenameFile<CR>", desc = "Rename File" },
  },
  settings = {
    completions = {
      completeFunctionCalls = true,
    },
  },
}

return M
