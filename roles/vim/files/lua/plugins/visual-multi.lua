return {
  'mg979/vim-visual-multi',
  keys = { { '<c-n>', mode = { 'n', 'x' } }, { '<c-e>', mode = 'x' } },
  init = function()
    vim.g.VM_maps = {
      ['Visual Cursors'] = '<c-e>',
    }
  end,
}
