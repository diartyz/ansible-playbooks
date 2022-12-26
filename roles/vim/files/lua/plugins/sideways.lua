return {
  'AndrewRadev/sideways.vim',
  config = function()
    vim.keymap.set('n', '[a', '<cmd>SidewaysLeft<cr>')
    vim.keymap.set('n', ']a', '<cmd>SidewaysRight<cr>')
  end,
}
