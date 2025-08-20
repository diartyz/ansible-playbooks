return {
  'akinsho/bufferline.nvim',
  version = '*',
  dependencies = 'nvim-tree/nvim-web-devicons',
  event = 'VeryLazy',
  config = function()
    require('bufferline').setup {
      options = {
        style_preset = require('bufferline').style_preset.no_italic,
        color_icons = false,
        indicator = { style = 'underline' },
        max_name_length = 99,
        max_prefix_length = 99,
        sort_by = 'directory',
        show_buffer_icons = false,
        tab_size = 0,
        truncate_names = false,
        numbers = function(opts)
          local state = require 'bufferline.state'
          for i, buf in ipairs(state.components) do
            if buf.id == opts.id then return i end
          end
          return opts.ordinal
        end,
      },
    }

    vim.keymap.set('n', '<leader>1', function() require('bufferline').go_to(1, true) end, { desc = 'go to buffer 1' })
    vim.keymap.set('n', '<leader>2', function() require('bufferline').go_to(2, true) end, { desc = 'go to buffer 2' })
    vim.keymap.set('n', '<leader>3', function() require('bufferline').go_to(3, true) end, { desc = 'go to buffer 3' })
    vim.keymap.set('n', '<leader>4', function() require('bufferline').go_to(4, true) end, { desc = 'go to buffer 4' })
    vim.keymap.set('n', '<leader>5', function() require('bufferline').go_to(5, true) end, { desc = 'go to buffer 5' })
    vim.keymap.set('n', '<leader>6', function() require('bufferline').go_to(6, true) end, { desc = 'go to buffer 6' })
    vim.keymap.set('n', '<leader>7', function() require('bufferline').go_to(7, true) end, { desc = 'go to buffer 7' })
    vim.keymap.set('n', '<leader>8', function() require('bufferline').go_to(8, true) end, { desc = 'go to buffer 8' })
    vim.keymap.set('n', '<leader>9', function() require('bufferline').go_to(9, true) end, { desc = 'go to buffer 9' })
    vim.keymap.set('n', '<leader>0', function() require('bufferline').go_to(10, true) end, { desc = 'go to buffer 10' })
    vim.keymap.set({ 'n', 'x' }, '<leader>X', '<cmd>BufferLinePickClose<cr>', { desc = 'pick and close buffer' })
    vim.keymap.set({ 'n', 'x' }, '<leader>d', '<cmd>BufferLineCloseOthers<cr>', { desc = 'close other buffers' })
    vim.keymap.set({ 'n', 'x' }, '<leader>t', '<cmd>BufferLinePick<cr>', { desc = 'pick buffer' })
    vim.keymap.set(
      { 'n', 'x' },
      '[B',
      function() require('bufferline').go_to(1, true) end,
      { desc = 'go to first buffer' }
    )
    vim.keymap.set(
      { 'n', 'x' },
      ']B',
      function() require('bufferline').go_to(0, true) end,
      { desc = 'go to last buffer' }
    )
    vim.keymap.set({ 'n', 'x' }, '[b', function()
      local count = vim.v.count > 0 and vim.v.count or 1
      for _ = 1, count do
        vim.cmd 'BufferLineCyclePrev'
      end
    end, { desc = 'go to previous buffer' })
    vim.keymap.set({ 'n', 'x' }, ']b', function()
      local count = vim.v.count > 0 and vim.v.count or 1
      for _ = 1, count do
        vim.cmd 'BufferLineCycleNext'
      end
    end, { desc = 'go to next buffer' })
  end,
}
