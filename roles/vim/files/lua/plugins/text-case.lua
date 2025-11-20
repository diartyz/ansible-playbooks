return {
  'johmsalas/text-case.nvim',
  dependencies = 'nvim-telescope/telescope.nvim',
  cmd = 'TextCaseOpenTelescope',
  keys = {
    { '<leader>c', '<cmd>TextCaseOpenTelescope<cr>', mode = { 'n', 'x' }, 'change text case' },
  },
  opts = {
    default_keymappings_enabled = false,
  },
}
