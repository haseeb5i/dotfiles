return {
  "akinsho/toggleterm.nvim",
  version = "*",
  event = "VeryLazy",
  dependencies = {
    { "stevearc/stickybuf.nvim", config = true },
  },
  opts = {
    size = 10, -- 20 for float
    open_mapping = [[<C-`>]],
    shading_factor = 2,
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
        local mapopts = { buffer = 0 }
        vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], mapopts)
        vim.keymap.set("t", "jk", [[<C-\><C-n>]], mapopts)
        vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], mapopts)
        vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], mapopts)
        vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], mapopts)
        vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], mapopts)
        vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], mapopts)
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
    -- :TermExec cmd="pipenv activate" -- size and dir also supported
    { "<leader>gg", "<cmd>lua _LAZYGIT_TOGGLE()<CR>", desc = " Lazygit" },
    { "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", desc = "Float" },
  },
}
