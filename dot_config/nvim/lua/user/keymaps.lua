local M = {}

M.general = {
  i = {
    ["jk"] = { "<Esc>", "Exit insert mode" },
    ["<C-b>"] = { "<ESC>^i", "論 beginning of line" },
    ["<C-e>"] = { "<End>", "壟 end of line" },
    ["<C-s>"] = { "<cmd> w <CR>", "﬚  Save File" },
  },

  n = {
    ["<leader>a"] = { "<cmd> Alpha <cr>", "Alpha" },
    -- switch between windows and buffers
    ["<C-h>"] = { "<C-w>h", " window left" },
    ["<C-l>"] = { "<C-w>l", " window right" },
    ["<C-j>"] = { "<C-w>j", " window down" },
    ["<C-k>"] = { "<C-w>k", " window up" },
    -- resize window
    ["<C-Up>"] = { "<cmd> resize +2<CR>", "Increase window height" },
    ["<C-Down>"] = { "<cmd> resize -2<CR>", "Decrease window height" },
    ["<C-Left>"] = { "<cmd> vertical resize +2<CR>", "Decrease window width" },
    ["<C-Right>"] = { "<cmd> vertical resize -2<CR>", "Increase window width" },
    -- save, close and quit
    ["<C-s>"] = { "<cmd> w <CR>", "Save File" },
    ["<C-q>"] = { "<cmd> qa <CR>", "Quit Neovim" },
    ["<leader>q"] = { "<cmd> q <CR>", "Quit Window" },
    ["<leader>c"] = { "<cmd> Bdelete <CR>", "Close Buffer" },

    ["<A-j>"] = { "<cmd> move .+1<CR>==", "Move text down" },
    ["<A-k>"] = { "<cmd> move .-2<CR>==", "Move text up" },

    -- Allow moving the cursor through wrapped lines with j, k, <Up> and <Down>
    -- http://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk/
    -- empty mode is same as using <cmd> :map
    -- also don't use g[j|k] when in operator pending mode, so it doesn't alter d, y or c behaviour
    -- ["j"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', opts = { expr = true } },
    -- ["k"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', opts = { expr = true } },
    -- ["<Up>"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', opts = { expr = true } },
    -- ["<Down>"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', opts = { expr = true } },

    -- open link in browser, only for unix
    ["gx"] = {
      '<cmd>call jobstart(["xdg-open", expand("<cfile>")], {"detach": v:true})<cr>',
      "Open link",
    },
  },

  v = {
    -- Stay in indent mode
    ["<"] = { "<gv", opts = { silent = true } },
    [">"] = { ">gv", opts = { silent = true } },
    -- Don't copy the replaced text after pasting in visual mode
    -- https://vim.fandom.com/wiki/Replace_a_word_with_yanked_text#Alternative_mapping_for_paste
    -- "_dP
    ["p"] = { 'p:let @+=@0<CR>:let @"=@0<CR>', opts = { silent = true } },
  },
  x = {
    ["<A-j>"] = { ":m '>+1<cr>gv", "Move text down" },
    ["<A-k>"] = { ":m '<-2<CR>gv", "Move text up" },
  },
}

-- TODO: fix this
-- vim.cmd [[
--   cnoremap <expr>  <C-j>  pumvisible() ? "<C-n>" : "<C-j>"
-- ]]
-- vim.keymap.set("c", "<C-j>", function()
--   return vim.fn.pumvisible() == 1 and "<C-n>" or "<C-j>"
-- end, { expr = true, noremap = true })

M.bufferline = {
  n = {
    -- TODO: map <cmd> BufferLinePick <cr>
    ["<S-l>"] = { "<cmd> BufferLineCycleNext <cr>", "Buffer right" },
    ["<S-h>"] = { "<cmd> BufferLineCyclePrev <cr>", "Buffer left" },
    ["<M-l>"] = { "<cmd> BufferLineMoveNext <cr>", "Buffer right" },
    ["<M-h>"] = { "<cmd> BufferLineMovePrev <cr>", "Buffer left" },
  },
}


M.nvimtree = {
  n = {
    ["<C-n>"] = { "<cmd> NvimTreeToggle <CR>", "  Toggle Nvimtree" },
    ["<leader>e"] = { "<cmd> NvimTreeFocus <CR>", "focus nvimtree" },
  },
}

M.mason = {
  n = {
    ["<leader>m"] = { "<cmd> Mason <cr>", "Mason Info" },
  },
}

M.telescope = {
  n = {
    ["<leader>f"] = {
      "<cmd> Telescope find_files theme=dropdown previewer=false<cr>",
      "Find Files",
    },
    ["<leader>F"] = {
      "<cmd> Telescope live_grep theme=ivy <CR>",
      "Live grep",
    },
    ["<leader>b"] = {
      "<cmd> Telescope buffers theme=dropdown previewer=false <cr>",
      "Buffers",
    },

    ["<leader>sw"] = {
      "<cmd> Telescope grep_string theme=ivy <cr>",
      "Search Word",
    },
    -- vim
    ["<leader>sc"] = { "<cmd> Telescope colorscheme<cr>", "Colorscheme" },
    ["<leader>sh"] = { "<cmd> Telescope help_tags<cr>", "Find Help" },
    ["<leader>sr"] = { "<cmd> Telescope oldfiles<cr>", "Open Recent File" },
    ["<leader>sR"] = { "<cmd> Telescope registers<cr>", "Registers" },
    ["<leader>sk"] = { "<cmd> Telescope keymaps<cr>", "Keymaps" },
    ["<leader>sC"] = { "<cmd> Telescope commands<cr>", "Commands" },
    -- git
    ["<leader>gf"] = { "<cmd>Telescope git_files<cr>", "Search git files" },
    ["<leader>go"] = { "<cmd>Telescope git_status<cr>", "Open changed files" },
    ["<leader>gb"] = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
    ["<leader>gc"] = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
  },
}

M.gitsigns = {
  n = {
    ["<leader>gg"] = { "<cmd>lua _LAZYGIT_TOGGLE()<CR>", "Lazygit" },
    ["<leader>gj"] = {
      "<cmd>lua require 'gitsigns'.next_hunk()<cr>",
      "Next Hunk",
    },
    ["<leader>gk"] = {
      "<cmd>lua require 'gitsigns'.prev_hunk()<cr>",
      "Prev Hunk",
    },
    ["<leader>gl"] = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame" },
    ["<leader>gp"] = {
      "<cmd>lua require 'gitsigns'.preview_hunk()<cr>",
      "Preview Hunk",
    },
    ["<leader>gr"] = {
      "<cmd>lua require 'gitsigns'.reset_hunk()<cr>",
      "Reset Hunk",
    },
    ["<leader>gR"] = {
      "<cmd>lua require 'gitsigns'.reset_buffer()<cr>",
      "Reset Buffer",
    },
    ["<leader>gs"] = {
      "<cmd>lua require 'gitsigns'.stage_hunk()<cr>",
      "Stage Hunk",
    },
    ["<leader>gu"] = {
      "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",
      "Undo Stage Hunk",
    },
    ["<leader>gd"] = { "<cmd>Gitsigns diffthis HEAD<cr>", "Diff" },
  },
}

-- <cmd>lua require('neogen').generate({
--     type = "func" -- can be func, class, type, file
-- })<cr>

M.dap = {
  n = {

    ["<leader>db"] = {
      "<cmd>lua require 'dap'.toggle_breakpoint()<cr>",
      "Toggle Breakpoint",
    },
    --   require("dap.ui.widgets").hover()
    ["<leader>dc"] = { "<cmd>lua require 'dap'.continue()<cr>", "Continue" },
    ["<leader>di"] = { "<cmd>lua require 'dap'.step_into()<cr>", "Step Into" },
    ["<leader>do"] = { "<cmd>lua require 'dap'.step_over()<cr>", "Step Over" },
    ["<leader>dO"] = { "<cmd>lua require 'dap'.step_out()<cr>", "Step Out" },
    ["<leader>dr"] = {
      "<cmd>lua require 'dap'.repl.toggle()<cr>",
      "Toggle REPL",
    },
    ["<leader>dl"] = { "<cmd>lua require 'dap'.run_last()<cr>", "Run Last" },
    ["<leader>dt"] = { "<cmd>lua require 'dap'.terminate()<cr>", "Terminate" },
    ["<leader>du"] = {
      "<cmd>lua require 'dapui'.toggle()<cr>",
      "Toggle DAP UI",
    },
  },
}

M.packer = {
  n = {
    ["<leader>pc"] = { "<cmd>PackerCompile<cr>", "Compile" },
    ["<leader>pi"] = { "<cmd>PackerInstall<cr>", "Install" },
    ["<leader>ps"] = { "<cmd>PackerSync<cr>", "Sync" },
    ["<leader>pS"] = { "<cmd>PackerStatus<cr>", "Status" },
    ["<leader>pu"] = { "<cmd>PackerUpdate<cr>", "Update" },
  },
}

M.terminal = {
  n = {
    ["<leader>tn"] = { "<cmd>lua _NODE_TOGGLE()<cr>", "Node" },
    ["<leader>tt"] = { "<cmd>lua _HTOP_TOGGLE()<cr>", "Htop" },
    ["<leader>tp"] = { "<cmd>lua _PYTHON_TOGGLE()<cr>", "Python" },
    ["<leader>tf"] = { "<cmd>ToggleTerm direction=float<cr>", "Float" },
    ["<leader>th"] = {
      "<cmd>ToggleTerm size=10 direction=horizontal<cr>",
      "Horizontal",
    },
    ["<leader>tv"] = {
      "<cmd>ToggleTerm size=80 direction=vertical<cr>",
      "Vertical",
    },
  },
}

M.session = {
  n = {
    ["<leader>r"] = { "<cmd> SessionManager load_session<cr>", "Load Session" },
  },
}

local function load_mappings(mappings)
  for mode, mode_values in pairs(mappings) do
    for keybind, keybind_info in pairs(mode_values) do
      local opts = keybind_info.opts or {}
      opts.desc = keybind_info[2]
      vim.keymap.set(mode, keybind, keybind_info[1], opts)
    end
  end
end

for _, section_mappings in pairs(M) do
  load_mappings(section_mappings)
end
