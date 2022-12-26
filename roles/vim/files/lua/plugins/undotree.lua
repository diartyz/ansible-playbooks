return {
  'mbbill/undotree',
  config = function()
    vim.g.undotree_SetFocusWhenToggle = 1
    vim.keymap.set('n', '<leader>u', '<cmd>UndotreeToggle<cr>')
  end,
}
