return {
  'folke/todo-comments.nvim',
  requires = 'nvim-lua/plenary.nvim',
  config = function()
    require('todo-comments').setup {
      highlight = {
        after = '',
        keyword = 'bg',
        pattern = '<(KEYWORDS)>',
      },
      search = {
        pattern = [[\b(KEYWORDS)\b]],
      },
    }
    vim.keymap.set('n', '<leader>p', '<cmd>TodoTelescope<cr>')
  end,
}
