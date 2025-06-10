return {
  'tpope/vim-unimpaired',
  dependencies = 'tpope/vim-repeat',
  keys = { '[', ']', 'yo' },
  config = function()
    local feed_keys = require('core.utils').feed_keys
    local next_conflict, prev_conflict = require('core/utils').make_repeatable_move_pair(
      function() feed_keys '<Plug>(unimpaired-context-next)' end,
      function() feed_keys '<Plug>(unimpaired-context-previous)' end
    )

    vim.keymap.set({ 'n', 'x' }, ']n', next_conflict, { desc = 'next conflict' })
    vim.keymap.set({ 'n', 'x' }, '[n', prev_conflict, { desc = 'prev conflict' })
  end,
}
