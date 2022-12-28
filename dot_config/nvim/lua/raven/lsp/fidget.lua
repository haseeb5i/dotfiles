local present, fidget = pcall(require, "fidget")
if not present then
  return
end

fidget.setup {
  window = { blend = 0 },
  sources = {
    ["null-ls"] = { ignore = true },
  },
}

vim.cmd "hi link FidgetTask Comment"
