local M = {}

-- Set keymaps in one go, follows lazy.nvim LazyKey spec
-- @param t LazyKey | LazyKey[]
function M.map(t)
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

-- Get highlight properties for a given highlight name
---@param name string highlight group name
---@return table highlight highlight group properties
function M.get_hlgroup(name, fallback)
  if vim.fn.hlexists(name) ~= 1 then
    return fallback
  end

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

---@param on_attach fun(client, buffer)
function M.on_attach(on_attach)
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local buffer = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      on_attach(client, buffer)
    end,
  })
end

return M
