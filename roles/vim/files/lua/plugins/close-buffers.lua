return {
  'kazhala/close-buffers.nvim',
  cmd = { 'Bdforce', 'Bdall' },
  config = function()
    require('close_buffers').setup()
    vim.api.nvim_create_user_command(
      'Bdforce',
      function() require('close_buffers').wipe { type = 'this' } end,
      { nargs = 0, desc = 'close buffers except current' }
    )
    vim.api.nvim_create_user_command(
      'Bdall',
      function() require('close_buffers').wipe { type = 'all' } end,
      { nargs = 0, desc = 'close all buffers' }
    )
  end,
}
