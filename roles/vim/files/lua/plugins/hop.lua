return {
  'phaazon/hop.nvim',
  config = function()
    require('hop').setup()
    vim.keymap.set('n', '<leader>/', '<cmd>HopPattern<cr>')
    vim.keymap.set('n', '<leader>t', '<cmd>HopChar2<cr>')
  end,
}
