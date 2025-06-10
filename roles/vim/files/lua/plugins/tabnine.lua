return {
  'codota/tabnine-nvim',
  build = './dl_binaries.sh',
  enabled = not vim.g.disable_ai,
  event = 'InsertEnter',
  config = function()
    require('tabnine').setup { accept_keymap = false }
    vim.keymap.set(
      'i',
      '<c-l>',
      require('tabnine.keymaps').accept_suggestion,
      { expr = true, desc = 'tabnine accept suggestion' }
    )
  end,
}
