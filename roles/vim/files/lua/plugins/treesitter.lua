return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  event = 'VeryLazy',
  config = function()
    require('nvim-treesitter.configs').setup {
      auto_install = true,
      ensure_installed = {
        'cpp',
        'javascript',
        'lua',
        'regex',
        'tsx',
        'typescript',
      },
      ignore_install = { 'html' },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
    }
  end,
}
