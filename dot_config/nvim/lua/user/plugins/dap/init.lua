local M = {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
  },
}

-- docs => https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation
-- configure adpaters
local abc = {
  python = {
    type = "executable",
    command = "path/to/virtualenvs/debugpy/bin/python",
    args = { "-m", "debugpy.adapter" },
  },
  node2 = {
    type = "executable",
    command = "node-debug2-adapter",
  },
}

-- configure debuggers, can modify with launch.json
local xyz = {
  python = {
    {
      -- The first three options are required by nvim-dap
      name = "Launch file",
      type = "python",
      request = "launch",
      -- Options below are for debugpy,
      -- see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings
      program = "${file}",
      pythonPath = function()
        local cwd = vim.fn.getcwd()
        if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
          return cwd .. "/venv/bin/python"
        elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
          return cwd .. "/.venv/bin/python"
        else
          return "/usr/bin/python"
        end
      end,
    },
  },
  scala = {
    {
      name = "RunOrTest",
      type = "scala",
      request = "launch",
      metals = {
        runType = "runOrTestFile",
        -- here just as an example
        --args = { "firstArg", "secondArg", "thirdArg" },
      },
    },
    {
      name = "Test Target",
      type = "scala",
      request = "launch",
      metals = {
        runType = "testTarget",
      },
    },
  },
}

-- docs => https://github.com/rcarriga/nvim-dap-ui#configuration
M.config = function()
  local dap = require "dap"
  local dapui = require "dapui"

  for k, v in pairs(abc) do
    dap.adapters[k] = v
  end

  for k, v in pairs(xyz) do
    dap.configurations[k] = v
  end

  dapui.setup {
    icons = { expanded = "⯆", collapsed = "⯈", circular = "↺" },
    layouts = {
      {
        elements = {
          "scopes",
          "breakpoints",
          "stacks",
          "watches",
        },
        size = 40,
        position = "left",
      },
      {
        elements = {
          "repl",
          "console",
        },
        size = 10,
        position = "bottom",
      },
    },
  }

  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
  end

  dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
  end

  dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
  end

  vim.fn.sign_define("DapBreakpoint", {
    text = "",
    texthl = "DiagnosticSignError",
    linehl = "",
    numhl = "",
  })

  vim.fn.sign_define("DapBreakpointRejected", {
    text = "",
    texthl = "LspDiagnosticsSignHint",
    linehl = "",
    numhl = "",
  })

  vim.fn.sign_define("DapStopped", {
    text = "",
    texthl = "LspDiagnosticsSignInformation",
    linehl = "DiagnosticUnderlineInfo",
    numhl = "LspDiagnosticsSignInformation",
  })
end

return M
