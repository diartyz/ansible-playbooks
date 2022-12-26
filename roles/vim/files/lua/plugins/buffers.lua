return {
  'kazhala/close-buffers.nvim',
  config = function()
    require('close_buffers').setup()
    vim.keymap.set('n', '<leader>d', function()
      require('close_buffers').wipe { type = 'other' }
      vim.cmd 'redrawtabline'
    end)
  end,
}
