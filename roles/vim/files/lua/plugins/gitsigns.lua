return {
  'lewis6991/gitsigns.nvim',
  event = 'VeryLazy',
  opts = {
    current_line_blame = true,
    signs = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '-' },
      untracked = { text = '┆' },
    },
    on_attach = function(bufnr)
      local gitsigns = require 'gitsigns'
      local next_hunk_repeat, prev_hunk_repeat =
        require('core/utils').make_repeatable_move_pair(gitsigns.next_hunk, gitsigns.prev_hunk)
      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      map('n', '<leader>hD', function() gitsigns.diffthis '~' end)
      map('n', '<leader>hR', gitsigns.reset_buffer)
      map('n', '<leader>hS', gitsigns.stage_buffer)
      map('n', '<leader>hb', function() gitsigns.blame_line { full = true } end)
      map('n', '<leader>hd', gitsigns.diffthis)
      map('n', '<leader>hq', gitsigns.preview_hunk)
      map('n', '<leader>hr', gitsigns.reset_hunk)
      map('n', '<leader>hs', gitsigns.stage_hunk)
      map('n', '<leader>hu', gitsigns.undo_stage_hunk)
      map('n', '[c', prev_hunk_repeat)
      map('n', ']c', next_hunk_repeat)
      map('v', '<leader>hr', function() gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' } end)
      map('v', '<leader>hs', function() gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' } end)
      map({ 'o', 'x' }, 'ih', '<cmd>Gitsigns select_hunk<cr>')
    end,
  },
}
