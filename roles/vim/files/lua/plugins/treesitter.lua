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

    vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
    vim.opt.foldmethod = 'expr'
    vim.opt.sessionoptions:remove 'folds'
  end,
}
