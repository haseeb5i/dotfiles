local colors = {}

function colors.gruvbox()
  require("gruvbox").setup {
    undercurl = true,
    underline = true,
    bold = false,
    italic = false,
    invert_signs = false,
    invert_tabline = false,
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

-- setup mode and colorscheme
vim.cmd "set background=dark"
pcall(colors.dracula)

vim.cmd [[
  hi! Pmenu guibg=none

  " hi! IndentBlanklineChar guifg=#404040 
  " hi! IndentBlanklineContextChar guifg=#707070

  hi link FidgetTask Comment

  hi! CmpItemAbbrMatch guibg=none
  hi! link CmpItemAbbrMatchFuzzy CmpItemAbbrMatch
  hi! CmpItemAbbrDeprecated gui=strikethrough guifg=#808080

  hi! CmpItemKindVariable guibg=none guifg=#9CDCFE
  hi! link CmpItemKindInterface CmpItemKindVariable
  hi! link CmpItemKindText CmpItemKindVariable

  hi! CmpItemKindFunction guibg=none guifg=#C586C0
  hi! link CmpItemKindMethod CmpItemKindFunction

  hi! CmpItemKindKeyword guibg=none guifg=#D4D4D4
  hi! link CmpItemKindProperty CmpItemKindKeyword
  hi! link CmpItemKindUnit CmpItemKindKeyword
]]

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
