local M = {
  "RRethy/vim-illuminate",
  event = "BufReadPost",
  keys = {
    {
      "]]",
      function()
        require("illuminate").goto_next_reference(false)
      end,
      desc = "Next Reference",
    },
    {
      "[[",
      function()
        require("illuminate").goto_prev_reference(false)
      end,
      desc = "Prev Reference",
    },
  },
}

function M.config()
  require("illuminate").configure {
    delay = 200,
    filetypes_denylist = {
      "NvimTree",
      "lazy",
      "mason",
      "help",
    },
  }
end

return M
