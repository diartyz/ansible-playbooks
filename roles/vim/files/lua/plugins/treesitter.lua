return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs',
    opts = {
      ensure_installed = {
        'javascript',
        'lua',
        'regex',
        'tsx',
        'typescript',
      },
      -- autotag = {
      --   enable = true,
      -- },
      textobjects = {
        move = {
          enable = true,
          goto_next_start = {
            [']]'] = '@function.outer',
          },
          goto_next_end = {
            [']['] = '@function.outer',
          },
          goto_previous_start = {
            ['[['] = '@function.outer',
          },
          goto_previous_end = {
            ['[]'] = '@function.outer',
          },
          goto_next = {
            [']d'] = { query = { '@conditional.*', '@loop.*' } },
          },
          goto_previous = {
            ['[d'] = { query = { '@conditional.*', '@loop.*' } },
          },
        },
        select = {
          enable = true,
          keymaps = {
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
          },
        },
      },
    },
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'ghostbuster91/nvim-next',
    },
    config = function()
      local ts_repeat_move = require 'nvim-treesitter.textobjects.repeatable_move'

      vim.keymap.set({ 'n', 'x', 'o' }, ';', ts_repeat_move.repeat_last_move)
      vim.keymap.set({ 'n', 'x', 'o' }, ',', ts_repeat_move.repeat_last_move_opposite)
      vim.keymap.set({ 'n', 'x', 'o' }, 'f', ts_repeat_move.builtin_f)
      vim.keymap.set({ 'n', 'x', 'o' }, 'F', ts_repeat_move.builtin_F)
      vim.keymap.set({ 'n', 'x', 'o' }, 't', ts_repeat_move.builtin_t)
      vim.keymap.set({ 'n', 'x', 'o' }, 'T', ts_repeat_move.builtin_T)
      vim.keymap.set(
        { 'n', 'x', 'o' },
        '<pageup>',
        function() ts_repeat_move.repeat_last_move { forward = false, start = true } end
      )
      vim.keymap.set(
        { 'n', 'x', 'o' },
        '<pagedown>',
        function() ts_repeat_move.repeat_last_move { forward = true, start = false } end
      )
    end,
  },
}
