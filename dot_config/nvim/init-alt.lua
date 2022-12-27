-- vim.api.nvim_create_autocmd("UIEnter", {
--   callback = function()
--     local pid = vim.loop.os_getpid()
--     local ctime = vim.loop.fs_stat("/proc/" .. pid).ctime
--     local start = ctime.sec + ctime.nsec / 1e9
--     local tod = { vim.loop.gettimeofday() }
--     local now = tod[1] + tod[2] / 1e6
--     local startuptime = (now - start) * 1000
--     vim.notify(startuptime .. "ms")
--   end,
-- })

require "user.options"
require "user.lazy"
require "user.keymaps"
