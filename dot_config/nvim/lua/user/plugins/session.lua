local M = {
  "Shatur/neovim-session-manager",
  event = "VeryLazy",
}
M.config = function()
  require("session_manager").setup {
    autoload_mode = require("session_manager.config").AutoloadMode.Disabled,
    autosave_last_session = true,
    autosave_ignore_dirs = {
      vim.env.HOME,
    },
    autosave_ignore_filetypes = {
      "alpha",
      "NvimTree",
      "gitcommit",
    },
  }
end

return M
