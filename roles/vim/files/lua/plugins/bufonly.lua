return {
  'vim-scripts/BufOnly.vim',
  config = function() vim.keymap.set('n', '<leader>d', '<cmd>BufOnly<cr><cmd>redrawtabline<cr>') end,
}
