return {
  'karb94/neoscroll.nvim',
  event = 'VeryLazy',
  config = function()
    local neoscroll = require 'neoscroll'
    local keymap = {
      ['<c-u>'] = function() neoscroll.ctrl_u { duration = 50 } end,
      ['<c-d>'] = function() neoscroll.ctrl_d { duration = 50 } end,
      ['<c-b>'] = function() neoscroll.ctrl_b { duration = 100 } end,
      ['<c-f>'] = function() neoscroll.ctrl_f { duration = 100 } end,
      ['zt'] = function() neoscroll.zt { half_win_duration = 50 } end,
      ['zz'] = function() neoscroll.zz { half_win_duration = 50 } end,
      ['zb'] = function() neoscroll.zb { half_win_duration = 50 } end,
    }
    local modes = { 'n', 'v', 'x' }
    for key, func in pairs(keymap) do
      vim.keymap.set(modes, key, func, { desc = 'neoscroll' })
    end
  end,
}
