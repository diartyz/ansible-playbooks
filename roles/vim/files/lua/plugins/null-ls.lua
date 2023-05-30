return {
  'jose-elias-alvarez/null-ls.nvim',
  dependencies = 'nvim-lua/plenary.nvim',
  config = function()
    local null_ls = require 'null-ls'

    null_ls.setup {
      sources = {
        null_ls.builtins.formatting.prettierd,
        null_ls.builtins.formatting.stylua.with {
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
