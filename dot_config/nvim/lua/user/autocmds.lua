local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

autocmd("FileType", {
  desc = "Enable spell check for some filetypes",
  pattern = { "gitcommit", "markdown" },
  command = "setlocal wrap spell",
})

autocmd("FileType", {
  desc = "Unlist quickfist buffers",
  group = augroup("unlist_quickfist", { clear = true }),
  pattern = "qf",
  callback = function()
    vim.opt_local.buflisted = false
  end,
})

autocmd("FileType", {
  desc = "Make q close help, man, quickfix, dap floats",
  group = augroup("q_close_windows", { clear = true }),
  pattern = { "qf", "help", "man", "dap-float", "lspinfo", "null-ls-info" },
  callback = function(event)
    vim.keymap.set(
      "n",
      "q",
      "<cmd>close<cr>",
      { buffer = event.buf, silent = true, nowait = true }
    )
  end,
})

autocmd("TextYankPost", {
  desc = "Highlight yanked text",
  group = augroup("highlightyank", { clear = true }),
  pattern = "*",
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- autocmd("ColorScheme", {
--   desc = "Load custom highlights from user configuration",
--   group = augroup("_highlights"),
--   callback = function()
--     vim.cmd [[ ]]
--   end
-- })

vim.api.nvim_create_autocmd("TermClose", {
  pattern = "*lazygit",
  callback = function()
    if package.loaded["neo-tree.sources.git_status"] then
      require("neo-tree.sources.git_status").refresh()
    end
  end,
})
