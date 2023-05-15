return {
  'folke/todo-comments.nvim',
  dependencies = 'nvim-lua/plenary.nvim',
  keys = {
    { '<leader>p', '<cmd>TodoTelescope<cr>' },
  },
  opts = {
    highlight = {
      after = '',
      keyword = 'bg',
      pattern = '<(KEYWORDS)>',
    },
    search = {
      pattern = [[\b(KEYWORDS)\b]],
    },
  },
}
