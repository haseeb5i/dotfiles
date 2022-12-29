local colors = {}

function colors.gruvbox()
  require("gruvbox").setup {
    undercurl = true,
    underline = true,
    bold = false,
    italic = false,
    invert_signs = false,
    invert_tabline = false,
    invert_intend_guides = false,
    overrides = {},
  }

  vim.cmd.colorscheme "gruvbox"
end

function colors.dracula()
  require("dracula").setup {
    italic_comment = true,
    overrides = {},
  }

  vim.cmd.colorscheme "dracula"
end

function colors.onedark()
  require("onedark").setup {
    style = "darker",
  }

  vim.cmd.colorscheme "onedark"
end

-- make neovim transparent
-- https://github.com/catppuccin/nvim/tree/main/lua/catppuccin/groups
-- vim.api.nvim_create_autocmd("ColorScheme",{
--   pattern = "*",
--   callback = function()
--       local groups = {
--         "DressingSelect",
--         "Folded",
--         "Normal",
--         "NormalFloat",
--         "NonText",
--         "NvimTreeNormal",
--         "NvimTreeVertSplit",
--         "Pmenu",
--         "SignColumn",
--       }
--       for _, group in ipairs(groups) do
--         vim.cmd.highlight(group .. " guibg=none")
--       end
--   end
-- })


vim.cmd [[
  hi! Pmenu guibg=none
  hi! CmpItemAbbrMatch guibg=none 
  hi! link CmpItemAbbrMatchFuzzy CmpItemAbbrMatch
  hi! CmpItemAbbrDeprecated gui=strikethrough
]]

-- setup a theme
vim.cmd "set background=dark"
pcall(colors.onedark)
