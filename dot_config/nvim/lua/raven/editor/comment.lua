local present, nvim_comment = pcall(require, "Comment")
if not present then
  return
end

-- https://github.com/numToStr/Comment.nvim#configuration-optional
nvim_comment.setup {
  ignore = "^$",
  toggler = {
    line = "gcc",
    block = "gbc",
  },
  mappings = {
    basic = true,
    extra = true,
    extended = false,
  },
  pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
}
