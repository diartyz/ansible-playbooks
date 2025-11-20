return {
  'dyng/ctrlsf.vim',
  cmd = 'CtrlSF',
  config = function()
    vim.g.ctrlsf_context = '-C 1'
    vim.g.ctrlsf_populate_qflist = 1
    vim.g.ctrlsf_regex_pattern = 1
    vim.g.ctrlsf_auto_focus = {
      at = 'start',
    }
    vim.g.ctrlsf_extra_backend_args = {
      ag = '--hidden --ignore-dir .git/ --nocolor',
      rg = '--hidden -g "!.git/" --color=never',
    }
  end,
}
