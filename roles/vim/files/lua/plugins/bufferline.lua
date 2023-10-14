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
        tab_size = 0,
        truncate_names = false,
      },
    }

    vim.keymap.set('n', '<leader>1', '<cmd>BufferLineGoToBuffer 1<cr>')
    vim.keymap.set('n', '<leader>2', '<cmd>BufferLineGoToBuffer 2<cr>')
    vim.keymap.set('n', '<leader>3', '<cmd>BufferLineGoToBuffer 3<cr>')
    vim.keymap.set('n', '<leader>4', '<cmd>BufferLineGoToBuffer 4<cr>')
    vim.keymap.set('n', '<leader>5', '<cmd>BufferLineGoToBuffer 5<cr>')
    vim.keymap.set('n', '<leader>6', '<cmd>BufferLineGoToBuffer 6<cr>')
    vim.keymap.set('n', '<leader>7', '<cmd>BufferLineGoToBuffer 7<cr>')
    vim.keymap.set('n', '<leader>8', '<cmd>BufferLineGoToBuffer 8<cr>')
    vim.keymap.set('n', '<leader>9', '<cmd>BufferLineGoToBuffer 9<cr>')
    vim.keymap.set('n', '<leader>0', '<cmd>BufferLineGoToBuffer 0<cr>')
    vim.keymap.set('n', '<leader>X', '<cmd>BufferLinePickClose<cr>')
    vim.keymap.set('n', '<leader>d', '<cmd>BufferLineCloseOthers<cr>')
    vim.keymap.set('n', '<leader>t', '<cmd>BufferLinePick<cr>')
    vim.keymap.set('n', '[B', function() require('bufferline').go_to(1, true) end)
    vim.keymap.set('n', ']B', function() require('bufferline').go_to(0, true) end)
    vim.keymap.set('n', '[b', function()
      local count = vim.v.count > 0 and vim.v.count or 1
      for _ = 1, count do
        vim.cmd 'BufferLineCyclePrev'
      end
    end)
    vim.keymap.set('n', ']b', function()
      local count = vim.v.count > 0 and vim.v.count or 1
      for _ = 1, count do
        vim.cmd 'BufferLineCycleNext'
      end
    end)
  end,
}
