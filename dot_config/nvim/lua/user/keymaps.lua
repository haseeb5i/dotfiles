local map = vim.keymap.set

-- insert mode maps
map("i", "jk", "<Esc>", { desc = "Exit insert mode" })
map("i", "<C-b>", "<ESC>^i", { desc = "論 beginning of line" })
map("i", "<C-e>", "<End>", { desc = "壟 end of line" })
map("i", "<C-s>", "<cmd> w <CR>", { desc = "﬚  Save File" })

-- switch between buffers
-- map("n", "", "<cmd> BufferLinePick <cr>")
map("n", "<S-l>", "<cmd> BufferLineCycleNext <cr>")
map("n", "<S-h>", "<cmd> BufferLineCyclePrev <cr>")
map("n", "<M-l>", "<cmd> BufferLineMoveNext <cr>")
map("n", "<M-h>", "<cmd> BufferLineMovePrev <cr>")

-- switch between windows
map("n", "<C-h>", "<C-w>h", { desc = " window left" })
map("n", "<C-l>", "<C-w>l", { desc = " window right" })
map("n", "<C-j>", "<C-w>j", { desc = " window down" })
map("n", "<C-k>", "<C-w>k", { desc = " window up" })

-- resize window
map("n", "<C-Up>", "<cmd> resize +2<CR>")
map("n", "<C-Down>", "<cmd> resize -2<CR>")
map("n", "<C-Left>", "<cmd> vertical resize +2<CR>")
map("n", "<C-Right>", "<cmd> vertical resize -2<CR>")

-- save, close and quit
map("n", "<C-s>", "<cmd> w <CR>", { desc = "Save File" })
map("n", "<C-q>", "<cmd> qa <CR>", { desc = "Quit Neovim" })

-- move lines
map("n", "<A-j>", "<cmd> move .+1<CR>==")
map("n", "<A-k>", "<cmd> move .-2<CR>==")
map("x", "<A-j>", ":m '>+1<cr>gv")
map("x", "<A-k>", ":m '<-2<CR>gv")
-- vim.keymap.set("n", "<A-j>", ":m .+1<CR>==")
-- vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv")
-- vim.keymap.set("i", "<A-j>", "<Esc>:m .+1<CR>==gi")
-- vim.keymap.set("n", "<A-k>", ":m .-2<CR>==")
-- vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv")
-- vim.keymap.set("i", "<A-k>", "<Esc>:m .-2<CR>==gi")
-- vim.keymap.set("n", "<C-Left>", "<cmd>bdelete<cr>")
-- vim.keymap.set("n", "<C-Left>", "<cmd>bprevious<cr>")
-- vim.keymap.set("n", "<C-Right>", "<cmd>bnext<cr>")

-- misc maps
map(
  "n",
  "gx",
  '<cmd>call jobstart(["xdg-open", expand("<cfile>")], {"detach": v:true})<cr>',
  { desc = "Open Link" }
)
-- allow moving the cursor through wrapped lines with j, k, <Up> and <Down>
-- http://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk/
-- empty mode is same as using <cmd> :map
-- also don't use g[j|k] when in operator pending mode, so it doesn't alter d, y or c behaviour
-- ["j"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', opts = { expr = true } },
-- ["k"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', opts = { expr = true } },
-- ["<Up>"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', opts = { expr = true } },
-- ["<Down>"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', opts = { expr = true } },

-- Stay in indent mode
-- ["<"] = { "<gv", opts = { silent = true } },
-- [">"] = { ">gv", opts = { silent = true } },
-- Don't copy the replaced text after pasting in visual mode
-- https://vim.fandom.com/wiki/Replace_a_word_with_yanked_text#Alternative_mapping_for_paste
-- "_dP
-- ["p"] = { 'p:let @+=@0<CR>:let @"=@0<CR>', opts = { silent = true } },

-- TODO: fix this
-- vim.cmd [[ cnoremap <expr>  <C-j>  pumvisible() ? "<C-n>" : "<C-j>" ]]
-- vim.keymap.set("c", "<C-j>", function()
--   return vim.fn.pumvisible() == 1 and "<C-n>" or "<C-j>"
-- end, { expr = true, noremap = true })

-- ["<C-n>"] = { "<cmd> NvimTreeToggle <CR>", "  Toggle Nvimtree" },
-- <cmd>lua require('neogen').generate({
--     type = "func" -- can be func, class, type, file
-- })<cr>

local wk = require "which-key"

wk.setup {
  plugins = {
    registers = true,
    presets = {
      operators = false,
      nav = false,
      windows = false,
    },
  },
  window = { border = "single" },
  layout = { spacing = 4 },
}

wk.register({
  a = { "<cmd> Alpha <cr>", "Alpha" },
  c = { "<cmd> Bdelete <cr>", "Close Buffer" },
  e = { "<cmd> NvimTreeFocus <cr>", "Focus NvimTree" },
  b = {
    "<cmd> Telescope buffers theme=dropdown previewer=false <cr>",
    "Buffers",
  },
  f = {
    "<cmd> Telescope find_files theme=dropdown previewer=false <cr>",
    "Find Files",
  },
  F = { "<cmd> Telescope live_grep theme=ivy <CR>", "Live grep" },
  m = { "<cmd> Mason <cr>", "Mason Info" },
  r = { "<cmd> SessionManager load_session<cr>", "Load Session" },
  q = { "<cmd> q <cr>", "Quit Window" },
  l = { name = "LSP" },
  w = { name = "Workspace" },

  g = {
    name = "+git",
    g = { "<cmd>lua _LAZYGIT_TOGGLE()<CR>", "Lazygit" },
    -- gitsigns
    j = { "<cmd>lua require'gitsigns'.next_hunk()<cr>", "Next Hunk" },
    k = { "<cmd>lua require'gitsigns'.prev_hunk()<cr>", "Prev Hunk" },
    l = { "<cmd>lua require'gitsigns'.blame_line()<cr>", "Blame" },
    p = { "<cmd>lua require'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
    r = { "<cmd>lua require'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
    R = { "<cmd>lua require'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
    s = { "<cmd>lua require'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
    u = { "<cmd>lua require'gitsigns'.undo_stage_hunk()<cr>", "Undo Stage Hunk" },
    d = { "<cmd>Gitsigns diffthis HEAD<cr>", "Open Diff" },
    -- d = { "<cmd>DiffviewOpen<cr>", "DiffView" },
    -- telescope
    f = { "<cmd>Telescope git_files<cr>", "Search git files" },
    o = { "<cmd>Telescope git_status<cr>", "Open changed files" },
    b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
    c = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
  },

  s = {
    name = "Search",
    w = { "<cmd> Telescope grep_string theme=ivy <cr>", "Search Word" },
    c = { "<cmd> Telescope colorscheme<cr>", "Colorscheme" },
    h = { "<cmd> Telescope help_tags<cr>", "Find Help" },
    r = { "<cmd> Telescope oldfiles<cr>", "Open Recent File" },
    R = { "<cmd> Telescope registers<cr>", "Registers" },
    k = { "<cmd> Telescope keymaps<cr>", "Keymaps" },
    C = { "<cmd> Telescope commands<cr>", "Commands" },
  },

  d = {
    name = "DAP",
    b = {
      "<cmd>lua require'dap'.toggle_breakpoint()<cr>",
      "Toggle Breakpoint",
    },
    c = { "<cmd>lua require'dap'.continue()<cr>", "Continue" },
    i = { "<cmd>lua require'dap'.step_into()<cr>", "Step Into" },
    o = { "<cmd>lua require'dap'.step_over()<cr>", "Step Over" },
    O = { "<cmd>lua require'dap'.step_out()<cr>", "Step Out" },
    r = { "<cmd>lua require'dap'.repl.toggle()<cr>", "Toggle REPL" },
    l = { "<cmd>lua require'dap'.run_last()<cr>", "Run Last" },
    t = { "<cmd>lua require'dap'.terminate()<cr>", "Terminate" },
    u = { "<cmd>lua require'dapui'.toggle()<cr>", "Toggle DAP UI" },
    -- require("dap.ui.widgets").hover()
    -- require("dapui").float_element(<element ID>, <optional settings>)
    -- require("dapui").eval(<expression>)
    -- vnoremap <M-k> <Cmd>lua require("dapui").eval()<CR>
  },

  p = {
    name = "Plugins",
    -- c = { "<cmd> PackerCompile <cr>", "Compile" },
    i = { "<cmd> Lazy Install <cr>", "Install" },
    -- i = { "<cmd> PackerInstall <cr>", "Install" },
    p = { "<cmd> Lazy profile <cr>", "Profile" },
    s = { "<cmd> Lazy sync <cr>", "Sync" },
    -- s = { "<cmd> PackerSync <cr>", "Sync" },
    S = { "<cmd> Lazy show <cr>", "Status" },
    -- S = { "<cmd> PackerStatus <cr>", "Status" },
    u = { "<cmd> Lazy update <cr>", "Update" },
    -- u = { "<cmd> PackerUpdate <cr>", "Update" },
  },

  t = {
    name = "Terminal",
    n = { "<cmd>lua _NODE_TOGGLE()<cr>", "Node" },
    t = { "<cmd>lua _HTOP_TOGGLE()<cr>", "Htop" },
    p = { "<cmd>lua _PYTHON_TOGGLE()<cr>", "Python" },
    f = { "<cmd>ToggleTerm direction=float<cr>", "Float" },
    h = { "<cmd>ToggleTerm size=10 direction=horizontal<cr>", "Horizontal" },
    v = { "<cmd>ToggleTerm size=80 direction=vertical<cr>", "Vertical" },
  },
}, { prefix = "<leader>" })
