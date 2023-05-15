return {
  'jose-elias-alvarez/null-ls.nvim',
  dependencies = 'nvim-lua/plenary.nvim',
  config = function()
    require('null-ls').setup {
      sources = {
        require('null-ls').builtins.code_actions.eslint_d,
        require('null-ls').builtins.diagnostics.eslint_d,
        require('null-ls').builtins.formatting.prettierd,
        require('null-ls').builtins.formatting.stylua.with {
          extra_args = {
            '--call-parentheses',
            'None',
            '--collapse-simple-statement',
            'Always',
            '--indent-type',
            'Spaces',
            '--indent-width',
            2,
            '--quote-style',
            'AutoPreferSingle',
          },
        },
      },
    }
  end,
}
