return {
  'tpope/vim-fugitive',
  cmd = 'G',
  keys = {
    { '<leader>gh', ':Gclog<cr>', mode = 'x' },
    { 'yog', '<cmd>G blame<cr>' },
  },
}
