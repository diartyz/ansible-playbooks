return {
  'folke/todo-comments.nvim',
  dependencies = 'nvim-lua/plenary.nvim',
  cmd = 'TodoTelescope',
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
