local M = {
  "rcarriga/nvim-dap-ui",
}

-- docs => https://github.com/rcarriga/nvim-dap-ui#configuration
function M.config()
  local dapui = require "dapui"
  local dap = require "dap"

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

  -- require("dapui").float_element(<element ID>, <optional settings>)
  -- require("dapui").eval(<expression>)
  -- vnoremap <M-k> <Cmd>lua require("dapui").eval()<CR>

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
