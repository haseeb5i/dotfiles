local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- don't list quickfix buffers
autocmd("FileType", {
  pattern = "qf",
  callback = function()
    vim.bo.buflisted = false
  end,
})

-- see if we should reload the file when it changed
autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  command = "checktime",
})

-- enable spell check for some filetypes
autocmd("FileType", {
  pattern = { "gitcommit", "markdown" },
  command = "setlocal wrap spell",
})

-- highlight text on yank
autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank { higroup = "Search", timeout = 200 }
  end,
  group = augroup("_yank_highlight", { clear = true }),
  pattern = "*",
})

-- make some windows close on <q>
autocmd("FileType", {
  pattern = {
    "qf",
    "help",
    "man",
    "floaterm",
    "lspinfo",
    "null-ls-info",
    "tsplayground",
  },
  command = "nnoremap <silent> <buffer> q :close<CR>",
})

autocmd("VimResized", {
  pattern = "*",
  command = "tabdo wincmd =",
  group = augroup("_auto_resize", { clear = true }),
})

autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    vim.cmd [[
      hi! Pmenu guibg=none

      hi! IndentBlanklineChar guifg=#404040
      " hi! IndentBlanklineContextChar guifg=#707070

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
  end,
})

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
