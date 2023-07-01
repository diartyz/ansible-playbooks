local function get_tsserver()
  for _, client in pairs(vim.lsp.get_active_clients()) do
    if client.name == 'tsserver' then return client end
  end
end

local function make_source_actions(source_action)
  return function(options)
    local client = get_tsserver()

    if not client then return end

    local method = 'textDocument/codeAction'
    local bufnr = vim.api.nvim_get_current_buf()
    local params = vim.lsp.util.make_range_params()
    local function apply_text_edits(res)
      if not res or not res[1] then return end
      vim.lsp.util.apply_text_edits(res[1].edit.documentChanges[1].edits, bufnr, client.offset_encoding)
    end

    params.context = {
      only = { source_action },
      diagnostics = vim.diagnostic.get(bufnr),
    }

    if options and options.async then
      client.request(method, params, function(err, res)
        assert(not err, err)
        apply_text_edits(res)
      end, bufnr)
    else
      local res = client.request_sync(method, params, nil, bufnr)
      apply_text_edits(res and res.result)
    end
  end
end

return {
  add_missing_imports = make_source_actions 'source.addMissingImports.ts',
  fix_all = make_source_actions 'source.fixAll.ts',
  organize_imports = make_source_actions 'source.organizeImports.ts',
  remove_unused = make_source_actions 'source.removeUnused.ts',
  remove_unused_imports = make_source_actions 'source.removeUnusedImports.ts',
  sort_imports = make_source_actions 'source.sortImports.ts',
}
