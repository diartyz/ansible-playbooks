return {
  'chaoren/vim-wordmotion',
  keys = {
    { 'B', mode = { 'n', 'x', 'o' } },
    { 'E', mode = { 'n', 'x', 'o' } },
    { 'W', mode = { 'n', 'x', 'o' } },
    { 'aW', mode = { 'x', 'o' } },
    { 'aw', mode = { 'x', 'o' } },
    { 'b', mode = { 'n', 'x', 'o' } },
    { 'e', mode = { 'n', 'x', 'o' } },
    { 'gE', mode = { 'n', 'x', 'o' } },
    { 'ge', mode = { 'n', 'x', 'o' } },
    { 'iW', mode = { 'x', 'o' } },
    { 'iw', mode = { 'x', 'o' } },
    { 'w', mode = { 'n', 'x', 'o' } },
  },
  init = function() vim.g.wordmotion_prefix = '<leader>' end,
}
