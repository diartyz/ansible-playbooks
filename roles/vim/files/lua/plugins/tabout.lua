return {
  'abecodes/tabout.nvim',
  dependencies = 'nvim-treesitter/nvim-treesitter',
  opts = {
    tabouts = {
      { open = "'", close = "'" },
      { open = '"', close = '"' },
      { open = '`', close = '`' },
      { open = '(', close = ')' },
      { open = '[', close = ']' },
      { open = '{', close = '}' },
      { open = '<', close = '>' },
    },
  },
}
