local autocmd = vim.api.nvim_create_autocmd

-- dont list quickfix buffers
autocmd("FileType", {
  pattern = "qf",
  callback = function()
    vim.opt_local.buflisted = false
  end,
})

-- don't auto-comment newlines
autocmd({ "BufWinEnter", "BufRead", "BufNewFile" }, {
  pattern = "*",
  command = "setlocal fo-=c fo-=r fo-=o",
})

-- enable spell check for some filetypes
autocmd("FileType", {
  pattern = { "gitcommit", "markdown" },
  command = "setlocal wrap spell",
})

-- highlight text on yank
autocmd("TextYankPost", {
  pattern = "*",
  callback = function()
    vim.highlight.on_yank { higroup = "Visual", timeout = 200 }
  end,
})

autocmd("FileType", {
  pattern = { "qf", "help", "man", "floaterm", "lspinfo", "null-ls-info" },
  command = "nnoremap <silent> <buffer> q :close<CR>",
})

vim.cmd [[
  augroup _auto_resize
    autocmd!
    autocmd VimResized * tabdo wincmd = 
  augroup end

  augroup cdpwd
    autocmd!
    autocmd VimEnter * cd $PWD
  augroup END

  augroup _alpha
    autocmd!
    autocmd User AlphaReady set showtabline=0 | autocmd BufUnload <buffer> set showtabline=2
  augroup end
]]
