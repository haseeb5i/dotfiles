local present, dressing = pcall(require, "dressing")
if not present then
  return
end

dressing.setup {
  select = {
    backend = { "builtin" },
    builtin = {
      win_options = {
        winblend = 0,
      },
    },
    get_config = function(opts)
      if opts.kind == "codeaction" then
        return {
          builtin = {
            relative = "cursor",
            min_height = 0,
          },
        }
      end
    end,
  },
}
