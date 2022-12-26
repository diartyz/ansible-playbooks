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
      lsp = {
        progress = {
          enabled = false,
        },
      },
    }
  end,
}
