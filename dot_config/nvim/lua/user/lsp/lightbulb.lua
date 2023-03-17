-- check for code action capability
-- local code_action_cap_found = false
-- for _, client in pairs(vim.lsp.get_active_clients()) do
--   if client.supports_method "textDocument/codeAction" then
--     code_action_cap_found = true
--     break
--   end
-- end

-- if not code_action_cap_found then
--   return
-- end

-- define code action available sign
SIGN_GROUP = "ca-lightbulb"
SIGN_NAME = "LightBulbSign"
vim.fn.sign_define(SIGN_NAME, { text = "💡", texthl = "LspDiagnosticsSignHint" })

vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
  pattern = "*",
  callback = function()
    local params = vim.lsp.util.make_range_params()
    local new_line = params.range.start.line + 1
    local diagnostics_info = vim.diagnostic.get(0, { lnum = new_line })
    params.context = { diagnostics = diagnostics_info }

    vim.lsp.buf_request_all(0, "textDocument/codeAction", params, function(responses)
      local has_actions = false
      for _, resp in pairs(responses) do
        if resp.result and not vim.tbl_isempty(resp.result) then
          has_actions = true
          break
        end
      end

      local bufnr = vim.api.nvim_get_current_buf()
      local old_line = vim.b.lightbulb_line
      if has_actions then
        if old_line ~= new_line then
          vim.fn.sign_unplace(SIGN_GROUP, { id = old_line, buffer = bufnr })
          vim.fn.sign_place(
            new_line,
            SIGN_GROUP,
            SIGN_NAME,
            bufnr,
            { lnum = new_line, priority = 150 }
          )
          vim.b.lightbulb_line = new_line
        end
      else
        if old_line then
          vim.fn.sign_unplace(SIGN_GROUP, { id = old_line, buffer = bufnr })
          vim.b.lightbulb_line = nil
        end
      end
    end)
  end,
})
