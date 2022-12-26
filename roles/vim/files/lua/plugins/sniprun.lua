return {
  'michaelb/sniprun',
  run = 'bash ./install.sh',
  config = function()
    require('sniprun').setup {
      display = {
        'NvimNotify',
      },
    }
    vim.keymap.set('v', '<leader>r', '<Plug>SnipRun')
  end,
}
