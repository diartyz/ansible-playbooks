return {
  'sainnhe/everforest',
  config = function()
    vim.g.everforest_background = 'hard'
    vim.g.everforest_better_performance = 1
    vim.g.everforest_diagnostic_line_highlight = 1
    vim.g.everforest_disable_italic_comment = 1
    vim.g.everforest_transparent_background = 0
    vim.g.everforest_ui_contrast = 1
    vim.api.nvim_command 'colorscheme everforest'
    vim.api.nvim_set_hl(0, 'LeapBackdrop', { link = 'Comment' })
    vim.api.nvim_set_hl(0, 'MatchupVirtualText', { link = 'Comment' })
    vim.api.nvim_set_hl(0, 'VM_Mono', { link = 'DiffAdd' })
    vim.diagnostic.config {
      signs = {
        linehl = {
          [vim.diagnostic.severity.ERROR] = 'ErrorLine',
          [vim.diagnostic.severity.HINT] = 'HintLine',
          [vim.diagnostic.severity.INFO] = 'InfoLine',
          [vim.diagnostic.severity.WARN] = 'WarningLine',
        },
        text = {
          [vim.diagnostic.severity.ERROR] = 'E',
          [vim.diagnostic.severity.HINT] = 'H',
          [vim.diagnostic.severity.INFO] = 'I',
          [vim.diagnostic.severity.WARN] = 'W',
        },
      },
    }
  end,
}
