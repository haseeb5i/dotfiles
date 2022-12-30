local M = {
  "RRethy/vim-illuminate",
  event = "BufRead",
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

M.config= function ()
  require("illuminate").configure {
    delay = 200,
    filetypes_denylist = {
      "alpha",
      "NvimTree",
      "lazy",
      "mason",
      "help",
    },
  }
end

return M
