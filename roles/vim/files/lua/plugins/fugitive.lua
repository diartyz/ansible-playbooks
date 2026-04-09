return {
  'tpope/vim-fugitive',
  cmd = 'G',
  keys = {
    { '<leader>gh', ':Gclog<cr>', mode = 'x', desc = 'git line history' },
    { 'yog', '<cmd>G blame<cr>', desc = 'toggle git blame' },
  },
}
