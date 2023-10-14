return {
  'sainnhe/everforest',
  config = function()
    vim.g.everforest_background = 'hard'
    vim.g.everforest_better_performance = 1
    vim.g.everforest_diagnostic_line_highlight = 1
    vim.g.everforest_disable_italic_comment = 1
    vim.g.everforest_sign_column_background = 'none'
    vim.g.everforest_transparent_background = 1
    vim.api.nvim_command 'colorscheme everforest'
    vim.api.nvim_command 'highlight Visual cterm=NONE ctermbg=241 gui=NONE guibg=#665c54'
    vim.fn.sign_define {
      {
        name = 'DiagnosticSignError',
        text = 'E',
        texthl = 'DiagnosticSignError',
        linehl = 'ErrorLine',
      },
      {
        name = 'DiagnosticSignWarn',
        text = 'W',
        texthl = 'DiagnosticSignWarn',
        linehl = 'WarningLine',
      },
      {
        name = 'DiagnosticSignInfo',
        text = 'I',
        texthl = 'DiagnosticSignInfo',
        linehl = 'InfoLine',
      },
      {
        name = 'DiagnosticSignHint',
        text = 'H',
        texthl = 'DiagnosticSignHint',
        linehl = 'HintLine',
      },
    }
  end,
}
