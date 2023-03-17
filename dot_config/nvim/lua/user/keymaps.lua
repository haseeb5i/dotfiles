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
  -- Don't copy the replaced text after pasting in visual mode
  -- https://vim.fandom.com/wiki/Replace_a_word_with_yanked_text#Alternative_mapping_for_paste
  { "p", 'p:let @+=@0<CR>:let @"=@0<CR>', mode = "x", silent = true },
  -- { "<", "<gv", mode = "v", silent = true },
  -- { ">", ">gv", mode = "v", silent = true },
  {
    "gx",
    '<cmd>call jobstart(["xdg-open", expand("<cfile>")], {"detach": v:true})<cr>',
    desc = "Open link under cursor",
  },
  -- TODO: fix this
  -- vim.cmd [[ cnoremap <expr>  <C-j>  pumvisible() ? "<C-n>" : "<C-j>" ]]
}

-- plugin manager
map {
  { "<leader>pi", "<cmd> Lazy Install <cr>", desc = "Install" },
  { "<leader>pp", "<cmd> Lazy profile <cr>", desc = "Profile" },
  { "<leader>ps", "<cmd> Lazy show <cr>", desc = "Status" },
  { "<leader>pS", "<cmd> Lazy sync <cr>", desc = "Sync" },
  { "<leader>pu", "<cmd> Lazy update <cr>", desc = "Update" },
}
