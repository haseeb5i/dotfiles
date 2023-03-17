return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    -- "Pocco81/dap-buddy.nvim"
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
  --     -- vim.keymap.set('n', '<Leader>B', function() require('dap').set_breakpoint() end)
  --     b = {
  --       "<cmd>lua require'dap'.toggle_breakpoint()<cr>",
  --       "Toggle Breakpoint",
  --     },
  --     c = { "<cmd>lua require'dap'.continue()<cr>", "Continue" },
  --     o = { "<cmd>lua require'dap'.step_over()<cr>", "Step Over" },
  --     i = { "<cmd>lua require'dap'.step_into()<cr>", "Step Into" },
  --     O = { "<cmd>lua require'dap'.step_out()<cr>", "Step Out" },
  --     r = { "<cmd>lua require'dap'.repl.toggle()<cr>", "Toggle REPL" },
  --     l = { "<cmd>lua require'dap'.run_last()<cr>", "Run Last" },
  --     t = { "<cmd>lua require'dap'.terminate()<cr>", "Terminate" },
  --     u = { "<cmd>lua require'dapui'.toggle()<cr>", "Toggle DAP UI" },
  --     h = { "<cmd>lua require'dap.ui.widgets'.hover()<cr>", "Hover" },
  --     p = { "<cmd>lua require'dap.ui.widgets'.preview()<cr>", "Preview" },
  --     -- require("dapui").float_element(<element ID>, <optional settings>)
  --     -- require("dapui").eval(<expression>)
  --     -- vnoremap <M-k> <Cmd>lua require("dapui").eval()<CR>
  --   },
}
