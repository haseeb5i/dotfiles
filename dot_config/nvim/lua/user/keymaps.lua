local map = require("user.utils").map

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
  -- { "<C-p>", "<cmd> BufferLinePick <cr>", desc = "Pick Buffer"},
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
  -- Don't copy the replaced text after pasting in visual mode
  -- https://vim.fandom.com/wiki/Replace_a_word_with_yanked_text#Alternative_mapping_for_paste
  { "p", 'p:let @+=@0<CR>:let @"=@0<CR>', mode = "x", silent = true },
  -- { "<", "<gv", mode = "v", silent = true },
  -- { ">", ">gv", mode = "v", silent = true },
  {
    "gx",
    function()
      -- use 'explorer' for win and 'open' for mac
      vim.fn.jobstart({ "xdg-open", vim.fn.expand "<cfile>" }, { detach = true })
    end,
    -- '<cmd>call jobstart(["xdg-open", expand("<cfile>")], {"detach": v:true})<cr>',
    desc = "Open link under cursor",
  },
  -- TODO: fix this
  -- vim.cmd [[ cnoremap <expr>  <C-j>  pumvisible() ? "<C-n>" : "<C-j>" ]]
}

-- defaults = {
--       mode = { "n", "v" },
--       ["g"] = { name = "+goto" },
--       ["gz"] = { name = "+surround" },
--       ["]"] = { name = "+next" },
--       ["["] = { name = "+prev" },
--       ["<leader><tab>"] = { name = "+tabs" },
--       ["<leader>b"] = { name = "+buffer" },
--       ["<leader>c"] = { name = "+code" },
--       ["<leader>f"] = { name = "+file/find" },
--       ["<leader>g"] = { name = "+git" },
--       ["<leader>gh"] = { name = "+hunks" },
--       ["<leader>q"] = { name = "+quit/session" },
--       ["<leader>s"] = { name = "+search" },
--       ["<leader>u"] = { name = "+ui" },
--       ["<leader>w"] = { name = "+windows" },
--       ["<leader>x"] = { name = "+diagnostics/quickfix" },
--     },

map {

  { "<leader>a", "<cmd> Alpha <cr>", desc = "Alpha" },
  { "<leader>q", "<cmd> q <cr>", desc = "Quit Window" },
  { "<leader>x", "<cmd> Bdelete <cr>", desc = "Close Buffer" },
  { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle NeoTree" },
  { "<leader>E", "<cmd>Neotree focus<cr>", desc = "Focus NeoTree" },
  { "<leader>r", "<cmd>SessionManager load_session<cr>", desc = "Load Session" },
}

-- plugin manager
map {
  { "<leader>pi", "<cmd> Lazy Install <cr>", desc = "Install" },
  { "<leader>pp", "<cmd> Lazy profile <cr>", desc = "Profile" },
  { "<leader>ps", "<cmd> Lazy show <cr>", desc = "Status" },
  { "<leader>pS", "<cmd> Lazy sync <cr>", desc = "Sync" },
  { "<leader>pu", "<cmd> Lazy update <cr>", desc = "Update" },
}

-- git
map {
  { "<leader>gj", "<cmd> Gitsigns next_hunk <cr>", desc = "Next Hunk" },
  { "<leader>gk", "<cmd> Gitsigns prev_hunk <cr>", desc = "Prev Hunk" },
  { "<leader>gl", "<cmd> Gitsigns blame_line <cr>", desc = "Blame" },
  { "<leader>gp", "<cmd> Gitsigns preview_hunk <cr>", desc = "Preview Hunk" },
  { "<leader>gr", "<cmd> Gitsigns reset_hunk <cr>", desc = "Reset Hunk" },
  { "<leader>gR", "<cmd> Gitsigns reset_buffer <cr>", desc = "Reset Buffer" },
  { "<leader>gs", "<cmd> Gitsigns stage_hunk <cr>", desc = "Stage Hunk" },
  { "<leader>gu", "<cmd> Gitsigns undo_stage_hunk <cr>", desc = "Undo Stage Hunk" },
  { "<leader>gd", "<cmd> DiffviewOpen<cr> ", desc = "Open DiffView" },
  { "<leader>gD", "<cmd> DiffviewClose<cr> ", desc = "Close DiffView" },
}

-- telescope
map {
  {
    "<leader>b",
    "<cmd> Telescope buffers theme=dropdown previewer=false <cr>",
    desc = "Find Buffers",
  },
  {
    "<leader>f",
    "<cmd> Telescope find_files theme=dropdown previewer=false <cr>",
    desc = "Find Files",
  },
  {
    "<leader>F",
    "<cmd> Telescope live_grep theme=ivy <CR>",
    desc = "Live grep",
  },
  -- search
  { "<leader>sc", "<cmd>Telescope colorscheme<cr>", desc = "Colorscheme" },
  { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Find Help" },
  { "<leader>sr", "<cmd>Telescope oldfiles<cr>", desc = "Open Recent File" },
  { "<leader>sR", "<cmd>Telescope registers<cr>", desc = "Registers" },
  { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
  { "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
  { "<leader>sw", "<cmd>Telescope grep_string theme=ivy<cr>", desc = "Search Word" },
  -- git
  { "<leader>gf", "<cmd>Telescope git_files<cr>", desc = "Search git files" },
  {
    "<leader>go",
    "<cmd>Telescope git_status<cr>",
    desc = "Open changed files",
  },
  { "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "Checkout branch" },
  { "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Checkout commit" },
}

-- illuminate
map {
  {
    "]]",
    function()
      require("illuminate").goto_next_reference(false)
    end,
    desc = "Next Reference",
  },
  {
    "[[",
    function()
      require("illuminate").goto_prev_reference(false)
    end,
    desc = "Prev Reference",
  },
}
-- also set it after loading ftplugins, since a lot overwrite [[ and ]]
-- vim.api.nvim_create_autocmd("FileType", {
--   callback = function()
--     local buffer = vim.api.nvim_get_current_buf()
--     map("]]", "next", buffer)
--     map("[[", "prev", buffer)
--   end,
-- })

-- neogen
map {
  {
    "<leader>cf",
    "<cmd>lua require'neogen'.generate{type = 'func'}<cr>",
    desc = "Function Annotation",
  },
  {
    "<leader>cc",
    "<cmd>lua require'neogen'.generate{type = 'class'}<cr>",
    desc = "Class Annotation",
  },
  {
    "<leader>ct",
    "<cmd>lua require'neogen'.generate{type = 'type'}<cr>",
    desc = "Type Annotation",
  },
  {
    "<leader>cF",
    "<cmd>lua require'neogen'.generate{type = 'file'}<cr>",
    desc = "File Annotation",
  },
}
--  { "<leader>,", "<cmd>Telescope buffers show_all_buffers=true<cr>", desc = "Switch Buffer" },
--     { "<leader>/", Util.telescope("live_grep"), desc = "Grep (root dir)" },
--     { "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Command History" },
--     { "<leader><space>", Util.telescope("files"), desc = "Find Files (root dir)" },
--     -- find
--     { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
--     { "<leader>ff", Util.telescope("files"), desc = "Find Files (root dir)" },
--     { "<leader>fF", Util.telescope("files", { cwd = false }), desc = "Find Files (cwd)" },
--     { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },
--     { "<leader>fR", Util.telescope("oldfiles", { cwd = vim.loop.cwd() }), desc = "Recent (cwd)" },
--     -- git
--     { "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "commits" },
--     { "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "status" },
--     -- search
--     { '<leader>s"', "<cmd>Telescope registers<cr>", desc = "Registers" },
--     { "<leader>sa", "<cmd>Telescope autocommands<cr>", desc = "Auto Commands" },
--     { "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer" },
--     { "<leader>sc", "<cmd>Telescope command_history<cr>", desc = "Command History" },
--     { "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
--     { "<leader>sd", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Document diagnostics" },
--     { "<leader>sD", "<cmd>Telescope diagnostics<cr>", desc = "Workspace diagnostics" },
--     { "<leader>sg", Util.telescope("live_grep"), desc = "Grep (root dir)" },
--     { "<leader>sG", Util.telescope("live_grep", { cwd = false }), desc = "Grep (cwd)" },
--     { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
--     { "<leader>sH", "<cmd>Telescope highlights<cr>", desc = "Search Highlight Groups" },
--     { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
--     { "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
--     { "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Jump to Mark" },
--     { "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Options" },
--     { "<leader>sR", "<cmd>Telescope resume<cr>", desc = "Resume" },
--     { "<leader>sw", Util.telescope("grep_string", { word_match = "-w" }), desc = "Word (root dir)" },
--     { "<leader>sW", Util.telescope("grep_string", { cwd = false, word_match = "-w" }), desc = "Word (cwd)" },
--     { "<leader>sw", Util.telescope("grep_string"), mode = "v", desc = "Selection (root dir)" },
--     { "<leader>sW", Util.telescope("grep_string", { cwd = false }), mode = "v", desc = "Selection (cwd)" },
--     { "<leader>uC", Util.telescope("colorscheme", { enable_preview = true }), desc = "Colorscheme with preview" },
--     {
--       "<leader>ss",
--       Util.telescope("lsp_document_symbols", {
--         symbols = {
--           "Class",
--           "Function",
--           "Method",
--           "Constructor",
--           "Interface",
--           "Module",
--           "Struct",
--           "Trait",
--           "Field",
--           "Property",
--         },
--       }),
--       desc = "Goto Symbol",
--     },
--     {
--       "<leader>sS",
--       Util.telescope("lsp_dynamic_workspace_symbols", {
--         symbols = {
--           "Class",
--           "Function",
--           "Method",
--           "Constructor",
--           "Interface",
--           "Module",
--           "Struct",
--           "Trait",
--           "Field",
--           "Property",
--         },
--       }),
--       desc = "Goto Symbol (Workspace)",
--     },
--   },
