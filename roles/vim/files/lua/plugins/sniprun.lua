return {
  'michaelb/sniprun',
  build = 'bash ./install.sh',
  dependencies = 'rcarriga/nvim-notify',
  keys = {
    { '<leader>r', '<Plug>SnipRun', mode = 'x' },
  },
  opts = {
    display = {
      'NvimNotify',
    },
  },
}
