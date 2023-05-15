return {
  'Exafunction/codeium.vim',
  config = function()
    vim.g.codeium_filetypes = {
      markdown = false,
    }
    vim.keymap.set('i', '<c-j>', function() return vim.fn['codeium#CycleCompletions'](1) end, { expr = true })
    vim.keymap.set('i', '<c-k>', function() return vim.fn['codeium#CycleCompletions'](-1) end, { expr = true })
  end,
}
