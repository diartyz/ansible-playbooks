return {
  'tpope/vim-unimpaired',
  dependencies = 'tpope/vim-repeat',
  keys = { ',', ';', '[', ']', 'yo' },
  config = function()
    local utils = require 'core.utils'
    local next_conflict, prev_conflict = utils.make_repeatable_pair(
      function() utils.feed_keys '<Plug>(unimpaired-context-next)' end,
      function() utils.feed_keys '<Plug>(unimpaired-context-previous)' end
    )
    vim.keymap.set({ 'n', 'x' }, ']n', next_conflict, { desc = 'next conflict' })
    vim.keymap.set({ 'n', 'x' }, '[n', prev_conflict, { desc = 'prev conflict' })
    vim.keymap.set({ 'n', 'x', 'o' }, ';', utils.repeat_last)
    vim.keymap.set({ 'n', 'x', 'o' }, ',', utils.repeat_opposite)
  end,
}
