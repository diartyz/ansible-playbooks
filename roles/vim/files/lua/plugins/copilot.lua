return {
  'github/copilot.vim',
  enabled = not vim.g.disable_ai,
  cmd = 'Copilot',
  event = 'InsertEnter',
  config = function()
    vim.g.copilot_no_tab_map = true
    vim.keymap.set('i', '<c-l>', '<Plug>(copilot-accept-line)')
    vim.keymap.set('i', '<c-y>', 'copilot#Accept("<cr>")', { expr = true, replace_keycodes = false })
  end,
}
