return {
  'abecodes/tabout.nvim',
  requires = 'nvim-treesitter/nvim-treesitter',
  config = function()
    require('tabout').setup {
      tabouts = {
        { open = "'", close = "'" },
        { open = '"', close = '"' },
        { open = '`', close = '`' },
        { open = '(', close = ')' },
        { open = '[', close = ']' },
        { open = '{', close = '}' },
        { open = '<', close = '>' },
      },
    }
  end,
}
