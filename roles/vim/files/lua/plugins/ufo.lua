return {
  'kevinhwang91/nvim-ufo',
  dependencies = 'kevinhwang91/promise-async',
  event = 'VeryLazy',
  config = function()
    require('ufo').setup { open_fold_hl_timeout = 0 }
    vim.opt.foldlevel = 99
    vim.opt.foldlevelstart = 99
  end,
}
