local present, npairs = pcall(require, "nvim-autopairs")
if not present then
  return
end

-- https://github.com/windwp/nvim-autopairs#default-values
npairs.setup {
  check_ts = true,
  ts_config = {
    lua = { "string", "source" },
    javascript = { "string", "template_string" },
    java = false,
  },
  disable_filetype = { "TelescopePrompt", "spectre_panel" },
  fast_wrap = {
    map = "<M-e>", -- M is short for meta key (can be alt key)
    chars = { "{", "[", "(", '"', "'", "`" },
    pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
    offset = 0,
    end_key = "$",
    keys = "qwertyuiopzxcvbnmasdfghjkl",
    check_comma = true,
    highlight = "PmenuSel",
    highlight_grey = "LineNr",
  },
}

-- maybe ts_utils is now integrated in neovim? check that
local ts_utils = require "nvim-treesitter.ts_utils"
local cmp_autopairs = require "nvim-autopairs.completion.cmp"
local cmp = require "cmp"

cmp.event:on("confirm_done", function(evt)
  local tsnode = ts_utils.get_node_at_cursor()
  if tsnode:type() ~= "named_imports" then
    cmp_autopairs.on_confirm_done()(evt)
  end
end)
