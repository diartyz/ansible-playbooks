return {
  'junegunn/vim-easy-align',
  config = function() vim.keymap.set({ 'n', 'x' }, 'ga', '<plug>(EasyAlign)') end,
}
