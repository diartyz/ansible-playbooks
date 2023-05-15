return {
  'lewis6991/gitsigns.nvim',
  opts = {
    current_line_blame = true,
    signs = {
      add = { hl = 'GitSignsAdd', text = '+', numhl = 'GitSignsAddNr', linehl = 'GitSignsAddLn' },
      change = { hl = 'GitSignsChange', text = '~', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
      changedelete = { hl = 'GitSignsChange', text = '-', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
    },
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns
      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      map('n', ']c', function()
        if vim.wo.diff then return ']c' end
        vim.schedule(function() gs.next_hunk() end)
        return '<Ignore>'
      end)
      map('n', '[c', function()
        if vim.wo.diff then return '[c' end
        vim.schedule(function() gs.prev_hunk() end)
        return '<Ignore>'
      end)
      map('n', '<leader>hR', gs.reset_buffer)
      map('n', '<leader>hS', gs.stage_buffer)
      map('n', '<leader>hd', gs.diffthis)
      map({ 'n', 'v' }, '<leader>hr', '<cmd>Gitsigns reset_hunk<cr>')
      map({ 'n', 'v' }, '<leader>hs', '<cmd>Gitsigns stage_hunk<cr>')
      map({ 'o', 'x' }, 'ih', '<cmd>Gitsigns select_hunk<cr>')
    end,
  },
}
