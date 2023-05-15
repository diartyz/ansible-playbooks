return {
  'nvim-telescope/telescope.nvim',
  dependencies = { 'nvim-lua/plenary.nvim', 'nvim-tree/nvim-web-devicons' },
  keys = {
    { '<c-p>', function() require('telescope.builtin').find_files() end },
    { '<leader>a', function() require('telescope.builtin').buffers() end },
    { '<leader>m', function() require('telescope.builtin').marks() end },
  },
  config = function()
    require('telescope').setup {
      defaults = require('telescope.themes').get_dropdown {
        file_ignore_patterns = { '^.git/.*' },
        mappings = {
          i = {
            ['<esc>'] = 'close',
            ['<c-j>'] = 'cycle_history_next',
            ['<c-k>'] = 'cycle_history_prev',
          },
        },
      },
      pickers = {
        buffers = {
          previewer = false,
          mappings = {
            i = {
              ['<c-d>'] = 'delete_buffer',
            },
          },
        },
        find_files = {
          hidden = true,
        },
      },
    }
  end,
}
