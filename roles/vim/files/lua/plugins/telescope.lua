return {
  'nvim-telescope/telescope.nvim',
  requires = { 'nvim-lua/plenary.nvim', 'kyazdani42/nvim-web-devicons' },
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
    vim.keymap.set('n', '<c-p>', require('telescope.builtin').find_files)
    vim.keymap.set('n', '<leader>a', require('telescope.builtin').buffers)
    vim.keymap.set('n', '<leader>m', require('telescope.builtin').marks)
  end,
}
