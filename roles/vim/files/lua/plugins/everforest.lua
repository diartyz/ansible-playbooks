return {
  'sainnhe/everforest',
  config = function()
    vim.g.everforest_background = 'hard'
    vim.g.everforest_better_performance = 1
    vim.g.everforest_diagnostic_line_highlight = 1
    vim.g.everforest_disable_italic_comment = 1
    vim.g.everforest_transparent_background = 1
    vim.g.everforest_ui_contrast = 1
    vim.api.nvim_command 'colorscheme everforest'
    vim.api.nvim_set_hl(0, 'LeapBackdrop', { link = 'Comment' })
    vim.api.nvim_set_hl(0, 'MatchupVirtualText', { link = 'Comment' })
    vim.api.nvim_set_hl(0, 'TabLineFill', { link = 'Normal' })
    vim.api.nvim_set_hl(0, 'VM_Mono', { link = 'DiffAdd' })
    vim.api.nvim_set_hl(0, 'Visual', { cterm = nil, ctermbg = 241, fg = nil, bg = '#665c54' })
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
