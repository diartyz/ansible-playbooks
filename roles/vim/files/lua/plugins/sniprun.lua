return {
  'michaelb/sniprun',
  build = 'bash ./install.sh',
  dependencies = {
    'rcarriga/nvim-notify',
    opts = {
      background_colour = '#252c31',
      fps = 60,
    },
  },
  keys = {
    { '<leader>r', '<Plug>SnipRun' },
  },
  opts = {
    display = {
      'NvimNotify',
    },
  },
}
