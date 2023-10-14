return {
  'dyng/ctrlsf.vim',
  cmd = 'CtrlSF',
  keys = {
    { '<c-s>', '<cmd>CtrlSFToggle<cr>' },
    { '<leader>f', '<plug>CtrlSFVwordPath', mode = 'x' },
    {
      '<leader>f',
      function()
        vim.api.nvim_feedkeys(
          vim.api.nvim_replace_termcodes(':CtrlSF ' .. (vim.g.ctrlsf_search_path or ''), true, false, true),
          'mi',
          true
        )
      end,
    },
  },
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
