return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  keys = {
    { '[[', function() Snacks.words.jump(-vim.v.count1) end, mode = { 'n', 't' }, desc = 'prev reference' },
    { ']]', function() Snacks.words.jump(vim.v.count1) end, mode = { 'n', 't' }, desc = 'next reference' },
  },
  config = function()
    require('snacks').setup {
      words = { enabled = true },
      input = {
        win = {
          relative = 'cursor',
          row = -3,
          keys = {
            i_esc = { '<esc>', { 'cmp_close', 'cancel' }, mode = 'i', expr = true },
          },
        },
      },
      picker = {
        win = {
          input = {
            keys = {
              ['<Esc>'] = { 'close', mode = { 'n', 'i' } },
            },
          },
        },
      },
    }
  end,
}
