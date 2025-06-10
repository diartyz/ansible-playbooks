return {
  'akinsho/bufferline.nvim',
  version = '*',
  dependencies = 'nvim-tree/nvim-web-devicons',
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

    vim.keymap.set('n', '<leader>1', function() require('bufferline').go_to(1, true) end)
    vim.keymap.set('n', '<leader>2', function() require('bufferline').go_to(2, true) end)
    vim.keymap.set('n', '<leader>3', function() require('bufferline').go_to(3, true) end)
    vim.keymap.set('n', '<leader>4', function() require('bufferline').go_to(4, true) end)
    vim.keymap.set('n', '<leader>5', function() require('bufferline').go_to(5, true) end)
    vim.keymap.set('n', '<leader>6', function() require('bufferline').go_to(6, true) end)
    vim.keymap.set('n', '<leader>7', function() require('bufferline').go_to(7, true) end)
    vim.keymap.set('n', '<leader>8', function() require('bufferline').go_to(8, true) end)
    vim.keymap.set('n', '<leader>9', function() require('bufferline').go_to(9, true) end)
    vim.keymap.set('n', '<leader>0', function() require('bufferline').go_to(10, true) end)
    vim.keymap.set({ 'n', 'x' }, '<leader>X', '<cmd>BufferLinePickClose<cr>')
    vim.keymap.set({ 'n', 'x' }, '<leader>d', '<cmd>BufferLineCloseOthers<cr>')
    vim.keymap.set({ 'n', 'x' }, '<leader>t', '<cmd>BufferLinePick<cr>')
    vim.keymap.set({ 'n', 'x' }, '[B', function() require('bufferline').go_to(1, true) end)
    vim.keymap.set({ 'n', 'x' }, ']B', function() require('bufferline').go_to(0, true) end)
    vim.keymap.set({ 'n', 'x' }, '[b', function()
      local count = vim.v.count > 0 and vim.v.count or 1
      for _ = 1, count do
        vim.cmd 'BufferLineCyclePrev'
      end
    end)
    vim.keymap.set({ 'n', 'x' }, ']b', function()
      local count = vim.v.count > 0 and vim.v.count or 1
      for _ = 1, count do
        vim.cmd 'BufferLineCycleNext'
      end
    end)
  end,
}
