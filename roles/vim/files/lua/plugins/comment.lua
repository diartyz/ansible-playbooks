return {
  'numToStr/Comment.nvim',
  keys = {
    'gbc',
    'gcc',
    { 'gb', mode = 'x' },
    { 'gc', mode = 'x' },
  },
  config = function()
    require('Comment').setup()

    local ft = require 'Comment.ft'
    ft.gn = '#%s'
  end,
}
