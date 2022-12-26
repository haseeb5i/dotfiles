local present, dap = pcall(require, "dap")
if not present then
  return
end

-- docs => https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation
-- configure adpaters
dap.adapters.python = {
  type = "executable",
  command = "path/to/virtualenvs/debugpy/bin/python",
  args = { "-m", "debugpy.adapter" },
}

dap.adapters.node2 = {
  type = "executable",
  command = "node-debug2-adapter",
}

-- configure debuggers, modify with launch.json
dap.configurations.python = {
  {
    -- The first three options are required by nvim-dap
    type = "python",
    request = "launch",
    name = "Launch file",

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
}

dap.configurations.scala = {
  {
    type = "scala",
    request = "launch",
    name = "RunOrTest",
    metals = {
      runType = "runOrTestFile",
      -- here just as an example
      --args = { "firstArg", "secondArg", "thirdArg" },
    },
  },
  {
    type = "scala",
    request = "launch",
    name = "Test Target",
    metals = {
      runType = "testTarget",
    },
  },
}
