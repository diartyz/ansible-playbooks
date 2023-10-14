return {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
  },
  keys = {
    { '<c-p>', function() require('telescope.builtin').find_files() end },
    { '<leader>a', function() require('telescope.builtin').buffers() end },
    {
      '<leader>p',
      function()
        vim.api.nvim_feedkeys(
          vim.api.nvim_replace_termcodes(
            ':Telescope find_files find_command=rg,--ignore,--hidden,--files,--glob,'
              .. (vim.g.telescope_search_path or ''),
            true,
            false,
            true
          ),
          'mi',
          true
        )
      end,
    },
  },
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
  end,
}
