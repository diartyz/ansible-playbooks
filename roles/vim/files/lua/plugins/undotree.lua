return {
  'mbbill/undotree',
  keys = {
    { '<leader>u', '<cmd>UndotreeToggle<cr>' },
  },
  config = function() vim.g.undotree_SetFocusWhenToggle = 1 end,
}
