local M = {
  "ggandor/leap.nvim",
  event = "VeryLazy",
  dependencies = {
    "ggandor/flit.nvim",
  },
}

function M.config()
  require("leap").add_default_mappings()

  require("flit").setup {
    labeled_modes = "nv",
  }
end

return M
