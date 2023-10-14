return {
  'j-hui/fidget.nvim',
  event = 'LspAttach',
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
