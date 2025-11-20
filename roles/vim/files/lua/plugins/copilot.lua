return {
  'github/copilot.vim',
  enabled = not vim.g.disable_ai,
  cmd = 'Copilot',
  event = 'InsertEnter',
  config = function()
    vim.keymap.set('i', '<c-down>', '<Plug>(copilot-accept-line)', { desc = 'copilot accept word' })
    vim.keymap.set('i', '<c-right>', '<Plug>(copilot-accept-word)', { desc = 'copilot accept word' })
    vim.keymap.set(
      'i',
      '<c-l>',
      'copilot#Accept("<cr>")',
      { desc = 'copilot accept', expr = true, replace_keycodes = false }
    )
  end,
}
