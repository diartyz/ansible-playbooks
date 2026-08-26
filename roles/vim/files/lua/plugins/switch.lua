return {
  'AndrewRadev/switch.vim',
  keys = '<c-t>',
  init = function()
    vim.g.switch_mapping = '<c-t>'
    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'javascriptreact', 'typescriptreact' },
      callback = function()
        vim.b.switch_custom_definitions = {
          -- "value" ↔ {`value`}
          { ['(\\w+)="(\\w+)"'] = '%1={`%2`}' },
          { ['(\\w+)=\\{[`\'"](%w+)[`\'"]\\}'] = '%1="%2"' },
          -- {var} ↔ {`${var`}
          { ['(\\w+)={([%w.]+)}'] = '%1={`${%2`}' },
          { ['(\\w+)=\\{`\\$\\{([%w.]+)\\}`\\}'] = '%1={%2}' },
        }
      end,
    })
  end,
}
