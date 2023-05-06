return {
  'folke/noice.nvim',
  requires = {
    'MunifTanjim/nui.nvim',
    {
      'rcarriga/nvim-notify',
      config = function()
        require('notify').setup {
          background_colour = '#252c31',
          fps = 60,
        }
      end,
    },
  },
  config = function()
    require('noice').setup {
      cmdline = {
        enabled = false,
      },
      messages = {
        enabled = false,
      },
      lsp = {
        progress = {
          enabled = false,
        },
      },
    }
  end,
}
