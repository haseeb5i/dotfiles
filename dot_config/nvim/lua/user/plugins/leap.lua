local M = {
  "ggandor/leap.nvim",
  event = "VeryLazy",
  dependencies = {
    {
      -- how this is loaded
      "ggandor/flit.nvim",
      config = { labeled_modes = "nv" },
    },
  },
  config = function()
    require("leap").add_default_mappings()
  end,
}

-- function M.config()
--   require("leap").add_default_mappings()
--   require("flit").setup {
--     labeled_modes = "nv",
--   }
-- end

return M
