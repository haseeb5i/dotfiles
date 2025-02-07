-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local term_mouse = vim.api.nvim_create_augroup("term_mouse", { clear = true })

vim.api.nvim_create_autocmd("TermEnter", {
  group = term_mouse,
  pattern = "*",
  callback = function()
    vim.opt.mouse = "n"
  end,
})

vim.api.nvim_create_autocmd("TermLeave", {
  group = term_mouse,
  pattern = "*",
  callback = function()
    vim.opt.mouse = "a"
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove({ "r", "o" })
  end,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "BlinkCmpMenuOpen",
  callback = function()
    -- require("copilot.suggestion").dismiss()
    vim.b.copilot_suggestion_hidden = true
  end,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "BlinkCmpMenuClose",
  callback = function()
    vim.b.copilot_suggestion_hidden = false
  end,
})
