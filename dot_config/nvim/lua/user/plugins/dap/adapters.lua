-- config for debuggers
return {
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
