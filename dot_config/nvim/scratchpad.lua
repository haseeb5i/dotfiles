---@diagnostic disable: unused-local, missing-parameter
---@diagnostic disable: unused-function

local function preview_location_callback(_, result)
  if result == nil or vim.tbl_isempty(result) then
    return nil
  end
  vim.pretty_print(result)
  vim.lsp.util.preview_location(result[1], {
    border = "rounded",
  })
end

local function preview_location_callback2(_, result)
  -- result might not be a table, check vim.tbl_islist(result)
  local location = result[1]
  local uri = location.targetUri
  if uri == nil then
    return
  end

  local bufnr = vim.uri_to_bufnr(uri)
  if not vim.api.nvim_buf_is_loaded(bufnr) then
    vim.fn.bufload(bufnr)
  end
  local range = location.targetRange
  local before_context = 0
  local context = 15
  local contents = vim.api.nvim_buf_get_lines(
    bufnr,
    range.start.line - before_context,
    range["end"].line + 1 + context,
    false
  )
  local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
  return vim.lsp.util.open_floating_preview(contents, filetype, {
    border = "rounded",
  })
end

function PeekD()
  local params = vim.lsp.util.make_position_params()
  vim.lsp.buf_request(
    0,
    "textDocument/definition",
    params,
    preview_location_callback2
  )
end

function SelectEnv()
  local venvs = {}
  -- local path = vim.env.XDG_DATA_HOME .. "/virtualenvs"
  local path = vim.env.XDG_CACHE_HOME .. "/pypoetry/virtualenvs"
  for i in vim.fs.dir(path) do
    venvs[#venvs + 1] = path .. "/" .. i
  end
  vim.ui.select(venvs, { prompt = "Select a virtualenv" }, function(item)
    if not item then
      return
    end
    vim.env.PATH = item .. "/bin:" .. vim.env.PATH
    -- vim.env.VIRTUAL_ENV = item
    vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
      pattern = "*.py",
      once = true,
      callback = function()
        vim.cmd "LspRestart"
      end,
    })
  end)
end

local x = { 1, 3, a = "b", c = "d" }

vim.pretty_print(vim.tbl_values(x))
vim.pretty_print(vim.tbl_keys(x))
vim.pretty_print(vim.tbl_filter(function(k, v)
  vim.pretty_print(k, v)
  return true
end, x))
