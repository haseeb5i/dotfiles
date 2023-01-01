local M = {
  "ggandor/leap.nvim",
  enabled = false,
  event = "VeryLazy",
  dependencies = {
    "ggandor/flit.nvim",
  },
}

M.config = function()
  require("leap").add_default_mappings()

  require("flit").setup {
    labeled_modes = "nv",
  }
end

return M
