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
      local next_hunk = function() gitsigns.nav_hunk('next', { target = 'all' }) end
      local prev_hunk = function() gitsigns.nav_hunk('prev', { target = 'all' }) end
      local next_hunk_repeat, prev_hunk_repeat = require('core/utils').make_repeatable_move_pair(next_hunk, prev_hunk)
      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      map('n', '<leader>hD', function() gitsigns.diffthis '~' end, { desc = 'git diff this' })
      map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'git reset buffer' })
      map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'git stage buffer' })
      map('n', '<leader>hb', function() gitsigns.blame_line { full = true } end, { desc = 'git blame line' })
      map('n', '<leader>hd', gitsigns.diffthis, { desc = 'git diff this' })
      map('n', '<leader>hq', gitsigns.preview_hunk, { desc = 'git preview hunk' })
      map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'git reset hunk' })
      map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'git stage hunk' })
      map('n', '<leader>hu', gitsigns.undo_stage_hunk, { desc = 'git unstage hunk' })
      map('n', '[C', function() gitsigns.nav_hunk('first', { target = 'all' }) end, { desc = 'git first hunk' })
      map('n', ']C', function() gitsigns.nav_hunk('last', { target = 'all' }) end, { desc = 'git last hunk' })
      map('n', '[c', prev_hunk_repeat, { desc = 'git prev hunk' })
      map('n', ']c', next_hunk_repeat, { desc = 'git next hunk' })
      map({ 'o', 'x' }, 'ih', '<cmd>Gitsigns select_hunk<cr>', { desc = 'git select hunk' })
      map(
        'v',
        '<leader>hr',
        function() gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' } end,
        { desc = 'git reset' }
      )
      map(
        'v',
        '<leader>hs',
        function() gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' } end,
        { desc = 'git stage' }
      )
    end,
  },
}
