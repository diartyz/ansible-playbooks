return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  keys = {
    { '<c-e>', function() Snacks.picker.explorer() end, desc = 'open explorer' },
    { '[[', function() Snacks.words.jump(-vim.v.count1) end, mode = { 'n', 't' }, desc = 'prev reference' },
    { ']]', function() Snacks.words.jump(vim.v.count1) end, mode = { 'n', 't' }, desc = 'next reference' },
  },
  config = function()
    require('snacks').setup {
      bigfile = { enabled = true },
      indent = { enabled = true },
      notifier = { enabled = true },
      quickfile = { enabled = true },
      scroll = { enabled = true },
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
        sources = {
          explorer = {
            auto_close = true,
            hidden = true,
            layout = { hidden = { 'input' } },
            win = {
              list = {
                keys = {
                  ['/'] = false,
                },
              },
            },
          },
        },
        win = {
          input = {
            keys = {
              ['<Esc>'] = { 'close', mode = { 'n', 'i' } },
            },
          },
        },
      },
    }
    vim.api.nvim_create_user_command('Blame', Snacks.git.blame_line, { nargs = 0, desc = 'git blame line' })
    vim.api.nvim_create_user_command(
      'Notifier',
      Snacks.notifier.show_history,
      { nargs = 0, desc = 'open notifier history' }
    )
  end,
}
