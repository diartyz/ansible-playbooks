return {
  'nvimtools/none-ls.nvim',
  dependencies = 'nvim-lua/plenary.nvim',
  event = 'VeryLazy',
  config = function()
    local null_ls = require 'null-ls'

    null_ls.setup {
      sources = {
        null_ls.builtins.formatting.black,
        null_ls.builtins.formatting.gn_format.with { command = vim.g.gn_path or 'gn' },
        null_ls.builtins.formatting.prettierd,
        null_ls.builtins.formatting.shfmt.with { filetypes = { 'sh', 'zsh' } },
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
