return {
  'lukas-reineke/indent-blankline.nvim',
  config = function()
    require('indent_blankline').setup()
    vim.keymap.set('n', '<c-g>', '<c-g><cmd>IndentBlanklineRefresh<cr>')
  end,
}
