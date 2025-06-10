return {
  'tpope/vim-fugitive',
  cmd = 'G',
  keys = {
    { '<leader>gb', '<cmd>G blame<cr>' },
    { '<leader>gh', ':Gclog<cr>', mode = 'x' },
  },
}
