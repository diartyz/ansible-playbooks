return {
  'github/copilot.vim',
  config = function()
    vim.g.copilot_assume_mapped = true
    vim.g.copilot_filetypes = {
      ['*'] = true,
    }
    vim.keymap.set('i', '<c-j>', '<Plug>(copilot-next)')
    vim.keymap.set('i', '<c-k>', '<Plug>(copilot-previous)')
  end,
}
