return {
  'folke/todo-comments.nvim',
  dependencies = 'nvim-lua/plenary.nvim',
  cmd = { 'TodoFzfLua', 'TodoTelescope' },
  event = 'VeryLazy',
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
