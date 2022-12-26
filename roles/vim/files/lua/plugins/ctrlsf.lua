return {
  'dyng/ctrlsf.vim',
  config = function()
    vim.g.ctrlsf_auto_focus = {
      at = 'start',
    }
    vim.g.ctrlsf_extra_backend_args = {
      ag = '--hidden --ignore-dir .git/ --nocolor',
      rg = '--hidden -g "!.git/" --color=never',
    }
    vim.g.ctrlsf_populate_qflist = 1
    vim.keymap.set('n', '<c-s>', '<cmd>CtrlSFToggle<cr>')
    vim.keymap.set('n', '<leader>f', '<plug>CtrlSFPrompt')
    vim.keymap.set('x', '<leader>f', '<plug>CtrlSFVwordPath')
  end,
}
