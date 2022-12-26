return {
  'nvim-treesitter/nvim-treesitter-context',
  requires = 'nvim-treesitter/nvim-treesitter',
  config = function() require('treesitter-context').setup() end,
}
