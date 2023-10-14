return {
  'chaoren/vim-wordmotion',
  keys = { '<leader>b', '<leader>e', '<leader>w', 'c', 'd', 'v', 'y' },
  init = function() vim.g.wordmotion_prefix = '<leader>' end,
}
