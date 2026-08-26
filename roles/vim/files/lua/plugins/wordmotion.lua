return {
  'chaoren/vim-wordmotion',
  keys = {
    { '<leader>b', mode = { 'n', 'x', 'o' } },
    { '<leader>e', mode = { 'n', 'x', 'o' } },
    { '<leader>ge', mode = { 'n', 'x', 'o' } },
    { '<leader>w', mode = { 'n', 'x', 'o' } },
    { 'a<leader>w', mode = { 'x', 'o' } },
    { 'i<leader>w', mode = { 'x', 'o' } },
  },
  init = function() vim.g.wordmotion_prefix = '<leader>' end,
}
