return {
  'mg979/vim-visual-multi',
  keys = {
    { '<c-e>', mode = 'x' },
    { '<c-n>', mode = { 'n', 'x' } },
  },
  init = function()
    vim.g.VM_maps = {
      ['Visual Cursors'] = '<c-e>',
    }
  end,
}
