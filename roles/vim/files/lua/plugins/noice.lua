return {
  'folke/noice.nvim',
  dependencies = {
    'MunifTanjim/nui.nvim',
    {
      'rcarriga/nvim-notify',
      opts = {
        background_colour = '#252c31',
      },
    },
  },
  opts = {
    lsp = {
      progress = {
        enabled = false,
      },
    },
    routes = {
      {
        filter = {
          event = 'msg_show',
          find = 'written',
        },
        opts = { skip = true },
      },
      {
        filter = {
          event = 'msg_show',
          find = 'search hit',
        },
        opts = { skip = true },
      },
    },
  },
}
