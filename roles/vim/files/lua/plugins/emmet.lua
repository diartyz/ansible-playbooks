return {
  'mattn/emmet-vim',
  init = function()
    vim.g.user_emmet_leader_key = '<c-;>'
    vim.g.user_emmet_next_key = '<c-j>'
    vim.g.user_emmet_prev_key = '<c-k>'
    vim.keymap.set('i', '<c-y>', '<plug>(emmet-expand-word)', { silent = true })
  end,
}
