return {
  'j-hui/fidget.nvim',
  event = 'LspProgress',
  opts = {
    notification = {
      window = {
        winblend = 0,
      },
    },
    integration = {
      ['nvim-tree'] = {
        enable = false,
      },
    },
  },
}
