return {
  'AndrewRadev/switch.vim',
  keys = '<leader>i',
  init = function()
    vim.g.switch_mapping = '<leader>i'
    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'javascriptreact', 'typescriptreact' },
      callback = function()
        vim.b.switch_custom_definitions = {
          {
            ['\\(\\k\\+=\\)"\\(\\k\\+\\)"'] = '\\1{`\\2`}',
            ['\\(\\k\\+=\\){[`"\']\\(\\k\\+\\)[`"\']}'] = '\\1"\\2"',
          },
          {
            ['\\(\\k\\+=\\){\\(\\(\\k\\|\\.\\)\\+\\)}'] = '\\1{`${\\2}`}',
            ['\\(\\k\\+=\\){`${\\(\\(\\k\\|\\.\\)\\+\\)}`}'] = '\\1{\\2}',
          },
        }
      end,
    })
  end,
}
