local M = {}

-- Get highlight properties for a given highlight name
-- @param name highlight group name
-- @return table of highlight group properties
function M.get_hlgroup(name, fallback)
  if vim.fn.hlexists(name) == 1 then
    local hl = vim.api.nvim_get_hl_by_name(name, vim.o.termguicolors)
    if not hl["foreground"] then
      hl["foreground"] = "NONE"
    end
    if not hl["background"] then
      hl["background"] = "NONE"
    end
    hl.fg, hl.bg, hl.sp = hl.foreground, hl.background, hl.special
    hl.ctermfg, hl.ctermbg = hl.foreground, hl.background
    return hl
  end
  return fallback
end

--- Open a URL under the cursor with the current operating system
-- @param path the path of the file to open with the system opener
-- function M.system_open(path)
--   local cmd
--   if vim.fn.has "win32" == 1 and vim.fn.executable "explorer" == 1 then
--     cmd = "explorer"
--   elseif vim.fn.has "unix" == 1 and vim.fn.executable "xdg-open" == 1 then
--     cmd = "xdg-open"
--   elseif (vim.fn.has "mac" == 1 or vim.fn.has "unix" == 1) and vim.fn.executable "open" == 1 then
--     cmd = "open"
--   end
--   if not cmd then M.notify("Available system opening tool not found!", "error") end
--   vim.fn.jobstart({ cmd, path or vim.fn.expand "<cfile>" }, { detach = true })
-- end

return M
