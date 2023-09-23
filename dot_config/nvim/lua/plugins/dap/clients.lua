-- config for debuggees, can be modified with launch.json
return {
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
