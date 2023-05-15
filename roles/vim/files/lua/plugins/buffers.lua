return {
  'kazhala/close-buffers.nvim',
  keys = {
    { '<leader>x', function() require('close_buffers').wipe { type = 'this' } end },
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
