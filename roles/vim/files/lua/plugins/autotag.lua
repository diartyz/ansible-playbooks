return {
  'windwp/nvim-ts-autotag',
  run = ':TSUpdate',
  requires = 'nvim-treesitter/nvim-treesitter',
  config = function() require('nvim-ts-autotag').setup() end,
}
