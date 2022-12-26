return {
  'tpope/vim-fugitive',
  config = function() vim.keymap.set('n', '<leader>gb', '<cmd>Git blame<cr>') end,
}
