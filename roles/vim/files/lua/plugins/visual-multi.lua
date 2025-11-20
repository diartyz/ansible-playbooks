return {
  'mg979/vim-visual-multi',
  keys = {
    { '<c-l>', mode = 'x', desc = 'multi cursors' },
    { '<c-n>', mode = { 'n', 'x' }, desc = 'multi cursors' },
  },
  init = function()
    vim.g.VM_maps = {
      ['Visual Cursors'] = '<c-l>',
    }
  end,
}
