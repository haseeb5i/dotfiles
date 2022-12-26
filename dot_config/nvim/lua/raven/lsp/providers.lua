local M = {}

local path = vim.split(package.path, ";")
table.insert(path, "lua/?.lua")
table.insert(path, "lua/?/init.lua")

M.sumneko_lua = {
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
        path = path,
      },
      completion = { callSnippet = "Both" },
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = {
          [vim.fn.expand "$VIMRUNTIME/lua"] = true,
          [vim.fn.stdpath "config" .. "/lua"] = true,
        },
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
        typeCheckingMode = "strict",
        useLibraryCodeForTypes = true,
        completeFunctionParens = true,
      },
    },
  },
  on_new_config = function(new_config)
    if vim.env.VIRTUAL_ENV ~= nil then
      return
    end

    local path = require("lspconfig.util").path
    local is_pipenv_root = path.exists "Pipfile"

    if is_pipenv_root then
      vim.notify "activating pipenv environment"
      -- existance of Pipfile doesn't guarantee venv presesne
      local return_text = vim.fn.system "pipenv --venv"
      if return_text:find "^No virtualenv" ~= nil then
        return
      end

      vim.env.VIRTUAL_ENV = vim.fn.trim(return_text)
      vim.env.PATH = vim.env.VIRTUAL_ENV .. "/bin:" .. vim.env.PATH
      vim.env.PIPENV_ACTIVE = "1"
      -- some other env vars set by pipenv
      -- SHLVL=2
      -- OLDPWD=/home/raven/Development/python/cses
      -- PIP_DISABLE_PIP_VERSION_CHECK=1
      -- PIP_PYTHON_PATH=/usr/bin/python3
      -- PYTHONDONTWRITEBYTECODE=1
      --
    end

    -- what does this do?
    new_config.settings.python.pythonPath = vim.fn.exepath "python"
  end,
}

return M
