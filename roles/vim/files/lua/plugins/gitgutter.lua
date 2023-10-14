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
      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      map('n', '<leader>hD', function() gitsigns.diffthis '~' end)
      map('n', '<leader>hR', gitsigns.reset_buffer)
      map('n', '<leader>hS', gitsigns.stage_buffer)
      map('n', '<leader>hb', function() gitsigns.blame_line({ full = true }, gitsigns.blame_line) end)
      map('n', '<leader>hd', gitsigns.diffthis)
      map('n', '<leader>hp', gitsigns.preview_hunk)
      map('n', '<leader>hr', gitsigns.reset_hunk)
      map('n', '<leader>hs', gitsigns.stage_hunk)
      map('n', '<leader>hu', gitsigns.undo_stage_hunk)
      map('n', '<leader>tb', gitsigns.toggle_current_line_blame)
      map('n', '<leader>td', gitsigns.toggle_deleted)
      map('n', '[c', gitsigns.prev_hunk)
      map('n', ']c', gitsigns.next_hunk)
      map('v', '<leader>hr', function() gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' } end)
      map('v', '<leader>hs', function() gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' } end)
      map({ 'o', 'x' }, 'ih', '<cmd>Gitsigns select_hunk<cr>')
    end,
  },
}
