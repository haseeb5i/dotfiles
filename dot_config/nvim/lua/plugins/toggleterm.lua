return {
  "akinsho/toggleterm.nvim",
  version = "*",
  event = "VeryLazy",
  opts = {
    size = 10, -- 20 for float
    open_mapping = [[<C-\>]],
    -- on_create = fun(t: Terminal),
    shading_factor = 2,
    persist_mode = false, -- TODO: check docs
    direction = "horizontal", -- "float"
    float_opts = {
      border = "curved",
      winblend = 0,
    },
  },
  config = function(_, opts)
    require("toggleterm").setup(opts)

    vim.api.nvim_create_autocmd("TermOpen", {
      pattern = "term://*",
      callback = function()
        local bufopts = { buffer = 0 }
        vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], bufopts)
        vim.keymap.set("t", "jk", [[<C-\><C-n>]], bufopts)
        vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], bufopts)
        vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], bufopts)
        vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], bufopts)
        vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], bufopts)
        vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], bufopts)
      end,
    })

    local Terminal = require("toggleterm.terminal").Terminal

    -- lazygit
    local lazygit = Terminal:new {
      cmd = "lazygit",
      hidden = true,
      dir = "git_dir",
      direction = "float",
      float_opts = {
        border = "single",
        winblend = 0,
      },
      on_open = function(term)
        vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = term.bufnr })
        -- remove mappings to escape to normal mode
        vim.api.nvim_buf_del_keymap(term.bufnr, "t", "<esc>")
        vim.api.nvim_buf_del_keymap(term.bufnr, "t", "jk")
      end,
    }
    function _LAZYGIT_TOGGLE()
      lazygit:toggle()
    end
  end,
  keys = {
    { "<leader>gg", "<cmd>lua _LAZYGIT_TOGGLE()<CR>", desc = " Lazygit" },
    -- :TermExec cmd="pipenv activate" -- size and dir also supported
    { "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", desc = "Float" },
    {
      "<leader>th",
      "<cmd>ToggleTerm size=10 direction=horizontal<cr>",
      desc = "Horizontal",
    },
    {
      "<leader>tv",
      "<cmd>ToggleTerm size=80 direction=vertical<cr>",
      desc = "Vertical",
    },
  },
}