return {
  'folke/noice.nvim',
  dependencies = {
    'MunifTanjim/nui.nvim',
    'rcarriga/nvim-notify',
  },
  event = 'VeryLazy',
  opts = {
    lsp = {
      progress = {
        enabled = false,
      },
      signature = {
        enabled = false,
      },
    },
    routes = {
      {
        filter = {
          event = 'msg_show',
          find = 'Backend Failure. Error messages:',
        },
        opts = { skip = true },
      },
      {
        filter = {
          event = 'msg_show',
          find = 'E486: Pattern not found:',
        },
        opts = { skip = true },
      },
      {
        filter = {
          event = 'msg_show',
          find = 'written',
        },
        opts = { skip = true },
      },
    },
  },
}
