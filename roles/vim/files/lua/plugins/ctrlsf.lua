return {
  'dyng/ctrlsf.vim',
  keys = {
    { '<c-s>', '<cmd>CtrlSFToggle<cr>' },
    { '<leader>f', '<plug>CtrlSFPrompt' },
    { '<leader>f', '<plug>CtrlSFVwordPath', mode = 'v' },
  },
  config = function()
    vim.g.ctrlsf_auto_focus = {
      at = 'start',
    }
    vim.g.ctrlsf_extra_backend_args = {
      ag = '--hidden --ignore-dir .git/ --nocolor',
      rg = '--hidden -g "!.git/" --color=never',
    }
    vim.g.ctrlsf_populate_qflist = 1
    vim.g.ctrlsf_regex_pattern = 1
  end,
}
