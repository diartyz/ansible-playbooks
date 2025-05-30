return {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
    },
  },
  cmd = 'Telescope',
  keys = { { '<leader>a', '<cmd>Telescope buffers<cr>', mode = { 'n', 'x' } } },
  config = function()
    require('telescope').setup {
      defaults = require('telescope.themes').get_dropdown {
        file_ignore_patterns = { '^.cache/', '^.git/', '^out/' },
        layout_config = { width = 0.9 },
        mappings = {
          i = {
            ['<esc>'] = 'close',
            ['<c-j>'] = 'cycle_history_next',
            ['<c-k>'] = 'cycle_history_prev',
          },
        },
      },
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
        },
      },
      pickers = {
        buffers = {
          layout_config = { height = 0.9 },
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
    require('telescope').load_extension 'fzf'
  end,
}
