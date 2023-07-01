return {
  'kazhala/close-buffers.nvim',
  keys = {
    {
      '<leader>d',
      function()
        require('close_buffers').wipe { type = 'other' }
        vim.cmd 'redrawtabline'
      end,
    },
  },
  config = true,
}
