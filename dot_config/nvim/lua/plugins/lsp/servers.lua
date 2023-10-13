local M = {}

M.lua_ls = {
  settings = {
    Lua = {
      telemetry = { enable = false },
    },
  },
}

M.metals = {
  keys = {
    {
      "<leader>cs",
      -- stylua: ignore
      function() require("metals").hover_worksheet() end,
      desc = "Hover Worksheet",
    },
  },
  settings = {
    metals = {
      excludedPackages = {
        "akka.actor.typed.javadsl",
        "com.github.swagger.akka.javadsl",
      },
      showImplicitArguments = true,
    },
  },
}

return M
