return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "Pocco81/dap-buddy.nvim",
  },
  config = function()
    local dap, dapui = require "dap", require "dapui"
    local debuggers = require "user.dap.adapters"
    local debuggees = require "user.dap.clients"

    for k, v in pairs(debuggers) do
      dap.adapters[k] = v
    end

    for k, v in pairs(debuggees) do
      dap.configurations[k] = v
    end

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
  end,
  keys = {
    { "<leader>db", "<cmd> DapToggleBreakpoint <cr>", desc = "Toggle Breakpoint" },
    { "<leader>dc", "<cmd> DapContinue <cr>", desc = "Continue" },
    { "<leader>do", "<cmd> DapStepOver <cr>", desc = "Step Over" },
    { "<leader>di", "<cmd> DapStepInto <cr>", desc = "Step Into" },
    { "<leader>dO", "<cmd> DapStepOut <cr>", desc = "Step Out" },
    { "<leader>dr", "<cmd> DapToggleRepl <cr>", desc = "Toggle REPL" },
    { "<leader>dl", "<cmd> DapRestartFrame <cr>", desc = "Run Last" },
    { "<leader>dL", "<cmd> DapLoadLaunchJSON <cr>", desc = "Load Launch JSON" },
    { "<leader>dt", "<cmd> DapTerminate <cr>", desc = "Terminate" },
    -- { "<leader>dh", "<cmd>lua require'dap.ui.widgets'.hover()<cr>",   desc = "Hover" },
    -- { "<leader>dp", "<cmd>lua require'dap.ui.widgets'.preview()<cr>", desc = "Preview" },
    { "<leader>du", "<cmd>lua require'dapui'.toggle()<cr>", desc = "Toggle DAP UI" },
    -- require("dapui").float_element(<element ID>, <optional settings>)
    -- vnoremap <M-k> <Cmd>lua require("dapui").eval(<expression>)<CR>
  },
}
