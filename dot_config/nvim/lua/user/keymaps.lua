local function map(t)
  local function set(args)
    local mode = args.mode or "n"

    local opts = {}
    for k, v in pairs(args) do
      if type(k) ~= "number" and k ~= "mode" then
        opts[k] = v
      end
    end

    vim.keymap.set(mode, args[1], args[2], opts)
  end

  if type(t[1]) == "table" then
    for _, keymap in ipairs(t) do
      set(keymap)
    end
  end

  if type(t[1]) == "string" then
    set(t)
  end
end

-- save, close and quit
map {
  { "<C-q>", "<cmd> qa <cr>" },
  { "<C-s>", "<cmd> w <CR>" },
  { "<C-s>", "<cmd> w <CR>", mode = "i" },
  { "<C-e>", "<End>", mode = "i" },
  { "<C-b>", "<ESC>^i", mode = "i" },
  { "jk", "<Esc>", mode = "i" },
}

-- switch between buffers
map {
  -- {"<S-l>", "<cmd> bnext <cr>", desc = "Next Buffer"},
  -- {"<S-h>", "<cmd> bprevious <cr>", desc = "Prev Buffer"},
  { "<S-l>", "<cmd> BufferLineCycleNext <cr>", desc = "Next Buffer" },
  { "<S-h>", "<cmd> BufferLineCyclePrev <cr>", desc = "Prev Buffer" },
  { "<M-l>", "<cmd> BufferLineMoveNext <cr>", desc = "Move Buffer Right" },
  { "<M-h>", "<cmd> BufferLineMovePrev <cr>", desc = "Move Buffer Left" },
  -- { "", "<cmd> BufferLinePick <cr>", desc = "Pick Buffer"},
}

-- switch between windows
map {
  { "<C-h>", "<C-w>h", desc = "Window Left" },
  { "<C-l>", "<C-w>l", desc = "Window Right" },
  { "<C-j>", "<C-w>j", desc = "Window Down" },
  { "<C-k>", "<C-w>k", desc = "Window Up" },
}

-- resize window
map {
  { "<C-S-Up>", "<cmd> resize +2<CR>" },
  { "<C-S-Down>", "<cmd> resize -2<CR>" },
  { "<C-S-Left>", "<cmd> vertical resize +2<CR>" },
  { "<C-S-Right>", "<cmd> vertical resize -2<CR>" },
}

-- move lines
map {
  { "<A-j>", "<cmd> move .+1<cr>==" },
  { "<A-k>", "<cmd> move .-2<cr>==" },
  { "<A-j>", ":m '>+1<cr>gv=gv", mode = "x" },
  { "<A-k>", ":m '<-2<cr>gv=gv", mode = "x" },
}

-- miscellaneous maps
map {
  -- { "<", "<gv", mode = "v", silent = true },
  -- { ">", ">gv", mode = "v", silent = true },
  -- Don't copy the replaced text after pasting in visual mode
  -- https://vim.fandom.com/wiki/Replace_a_word_with_yanked_text#Alternative_mapping_for_paste
  { "p", 'p:let @+=@0<CR>:let @"=@0<CR>', mode = "x", silent = true },
  {
    "gx",
    '<cmd>call jobstart(["xdg-open", expand("<cfile>")], {"detach": v:true})<cr>',
    desc = "Open link under cursor",
  },
}
-- TODO: fix this
-- vim.cmd [[ cnoremap <expr>  <C-j>  pumvisible() ? "<C-n>" : "<C-j>" ]]

-- map {
--   {
--     "]]",
--     function()
--       require("illuminate").goto_next_reference(false)
--     end,
--     desc = "Next Reference",
--   },
--   {
--     "[[",
--     function()
--       require("illuminate").goto_prev_reference(false)
--     end,
--     desc = "Prev Reference",
--   },
-- }

local wk = require "which-key"

wk.register({
  a = { "<cmd> Alpha <cr>", "Alpha" },
  e = { "<cmd> Neotree <cr>", "Open Explorer" },
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
  c = { "<cmd> Bdelete <cr>", "Close Buffer" },
  l = { name = "LSP" },
  w = { name = "Workspace" },

  -- c = {
  --   name = "Code",
  --   f = {
  --     "<cmd>lua require'neogen'.generate{type = 'func'}<cr>",
  --     "Function Annotation",
  --   },
  --   c = {
  --     "<cmd>lua require'neogen'.generate{type = 'class'}<cr>",
  --     "Class Annotation",
  --   },
  --   t = { "<cmd>lua require'neogen'.generate{type = 'type'}<cr>", "Type Annotation" },
  --   F = { "<cmd>lua require'neogen'.generate{type = 'file'}<cr>", "File Annotation" },
  -- },

  g = {
    name = "Git",
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
    -- d = { "<cmd>Gitsigns diffthis HEAD<cr>", "Open Diff" },
    d = { "<cmd>DiffviewOpen<cr>", desc = "DiffView" },
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
  -- :help dap-mappings
  d = {
    name = "DAP",
    -- vim.keymap.set('n', '<Leader>B', function() require('dap').set_breakpoint() end)
    b = {
      "<cmd>lua require'dap'.toggle_breakpoint()<cr>",
      "Toggle Breakpoint",
    },
    c = { "<cmd>lua require'dap'.continue()<cr>", "Continue" },
    o = { "<cmd>lua require'dap'.step_over()<cr>", "Step Over" },
    i = { "<cmd>lua require'dap'.step_into()<cr>", "Step Into" },
    O = { "<cmd>lua require'dap'.step_out()<cr>", "Step Out" },
    r = { "<cmd>lua require'dap'.repl.toggle()<cr>", "Toggle REPL" },
    l = { "<cmd>lua require'dap'.run_last()<cr>", "Run Last" },
    t = { "<cmd>lua require'dap'.terminate()<cr>", "Terminate" },
    u = { "<cmd>lua require'dapui'.toggle()<cr>", "Toggle DAP UI" },
    h = { "<cmd>lua require'dap.ui.widgets'.hover()<cr>", "Hover" },
    p = { "<cmd>lua require'dap.ui.widgets'.preview()<cr>", "Preview" },
    -- require("dapui").float_element(<element ID>, <optional settings>)
    -- require("dapui").eval(<expression>)
    -- vnoremap <M-k> <Cmd>lua require("dapui").eval()<CR>
  },

  p = {
    name = "Plugins",
    i = { "<cmd> Lazy Install <cr>", "Install" },
    p = { "<cmd> Lazy profile <cr>", "Profile" },
    s = { "<cmd> Lazy show <cr>", "Status" },
    S = { "<cmd> Lazy sync <cr>", "Sync" },
    u = { "<cmd> Lazy update <cr>", "Update" },
    -- c = { "<cmd> PackerCompile <cr>", "Compile" },
    -- i = { "<cmd> PackerInstall <cr>", "Install" },
    -- s = { "<cmd> PackerSync <cr>", "Sync" },
    -- S = { "<cmd> PackerStatus <cr>", "Status" },
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
