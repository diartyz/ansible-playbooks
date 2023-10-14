return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  dependencies = 'nvim-treesitter/nvim-treesitter-textobjects',
  event = 'VeryLazy',
  config = function()
    require('nvim-treesitter.configs').setup {
      auto_install = true,
      ensure_installed = {
        'cpp',
        'javascript',
        'lua',
        'regex',
        'tsx',
        'typescript',
      },
      ignore_install = { 'html' },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
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
    vim.keymap.set({ 'n', 'x', 'o' }, ';', ts_repeat_move.repeat_last_move_next)
    vim.keymap.set({ 'n', 'x', 'o' }, ',', ts_repeat_move.repeat_last_move_previous)
    vim.keymap.set({ 'n', 'x', 'o' }, 'f', ts_repeat_move.builtin_f_expr, { expr = true })
    vim.keymap.set({ 'n', 'x', 'o' }, 'F', ts_repeat_move.builtin_F_expr, { expr = true })
    vim.keymap.set({ 'n', 'x', 'o' }, 't', ts_repeat_move.builtin_t_expr, { expr = true })
    vim.keymap.set({ 'n', 'x', 'o' }, 'T', ts_repeat_move.builtin_T_expr, { expr = true })
    vim.opt.foldlevel = 99
    vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
    vim.opt.foldmethod = 'expr'
    vim.opt.sessionoptions:remove 'folds'
  end,
}
