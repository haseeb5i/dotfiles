local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- don't list quickfix buffers
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
    vim.highlight.on_yank { higroup = "Search", timeout = 200 }
  end,
})

-- make some windows easy to close
autocmd("FileType", {
  pattern = { "qf", "help", "man", "floaterm", "lspinfo", "null-ls-info" },
  command = "nnoremap <silent> <buffer> q :close<CR>",
})

autocmd("VimResized", {
  pattern = "*",
  command = "tabdo wincmd =",
  group = augroup("_auto_resize", { clear = true }),
})
