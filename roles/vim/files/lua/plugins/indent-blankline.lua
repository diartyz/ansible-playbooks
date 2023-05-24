return {
  'lukas-reineke/indent-blankline.nvim',
  config = function()
    require('indent_blankline').setup {
      show_current_context = true,
    }
    vim.keymap.set('n', '<c-g>', '<c-g><cmd>IndentBlanklineRefresh<cr>')
  end,
}
