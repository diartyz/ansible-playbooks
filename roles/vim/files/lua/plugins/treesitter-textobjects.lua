return {
  'nvim-treesitter/nvim-treesitter-textobjects',
  dependencies = 'nvim-treesitter/nvim-treesitter',
  event = 'VeryLazy',
  config = function()
    require('nvim-treesitter.configs').setup {
      textobjects = {
        move = {
          enable = true,
          goto_next_start = {
            [']]'] = '@function.outer',
            [']a'] = '@parameter.inner',
            [']z'] = { query = '@fold', query_group = 'folds' },
          },
          goto_previous_end = {
            ['[['] = '@function.outer',
            ['[a'] = '@parameter.inner',
            ['[z'] = { query = '@fold', query_group = 'folds' },
          },
        },
        select = {
          enable = true,
          keymaps = {
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
          },
        },
        swap = {
          enable = true,
          swap_next = {
            [']['] = '@parameter.inner',
          },
          swap_previous = {
            ['[]'] = '@parameter.inner',
          },
        },
      },
    }

    local ts_repeat_move = require 'nvim-treesitter.textobjects.repeatable_move'
    vim.keymap.set(
      { 'n', 'x', 'o' },
      ';',
      ts_repeat_move.repeat_last_move_next,
      { desc = 'ts_repeat_move.repeat_last_move_next' }
    )
    vim.keymap.set(
      { 'n', 'x', 'o' },
      ',',
      ts_repeat_move.repeat_last_move_previous,
      { desc = 'ts_repeat_move.repeat_last_move_next' }
    )
  end,
}
