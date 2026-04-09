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
    presets = {
      bottom_search = true,
      long_message_to_split = true,
    },
  },
}
