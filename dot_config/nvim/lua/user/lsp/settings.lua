local M = {}

M.sumneko_lua = {
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
  -- slow startup, activate venv with pipenv shell or
  -- poetry shell command and then start nvim/neovide
  -- on_new_config = function(new_config)
  -- if venv is active, don't change anything
  -- if vim.env.VIRTUAL_ENV then
  --   return
  -- end

  -- check if poetry
  -- local poetry_return = vim.fn.system "poetry env info --path"
  -- if vim.v.shell_error == 0 then
  --   local venv_path = vim.fn.trim(poetry_return)
  --   vim.env.PATH = venv_path .. "/bin:" .. vim.env.PATH
  --   new_config.settings.python.pythonPath = venv_path .. "/bin/python"
  --   return
  -- end
  -- local pipenv_return = vim.fn.system "pipenv --venv"
  -- local venv_path = vim.fn.trim(pipenv_return:match "/home.+")
}

return M
