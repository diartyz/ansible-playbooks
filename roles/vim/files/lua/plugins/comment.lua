return {
  'numToStr/Comment.nvim',
  dependencies = {
    'JoosepAlviste/nvim-ts-context-commentstring',
    dependencies = 'nvim-treesitter/nvim-treesitter',
  },
  keys = {
    'gcc',
    { 'gc', mode = 'x' },
  },
  config = function()
    require('Comment').setup {
      pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
    }

    local ft = require 'Comment.ft'
    ft.gn = '#%s'
  end,
}
