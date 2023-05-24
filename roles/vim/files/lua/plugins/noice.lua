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
  },
}
