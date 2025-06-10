return {
  'olimorris/codecompanion.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  enabled = not vim.g.disable_ai,
  cmd = 'AI',
  config = function()
    require('codecompanion').setup {
      strategies = {
        chat = { adapter = 'copilot' },
        inline = { adapter = 'copilot' },
      },
    }

    vim.api.nvim_create_user_command('AI', 'CodeCompanionChat Toggle', { nargs = 0 })
  end,
}
