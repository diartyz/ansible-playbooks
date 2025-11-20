return {
  'ggandor/leap.nvim',
  keys = {
    { 'F', mode = { 'n', 'o', 'x' } },
    { 'T', mode = { 'n', 'o', 'x' } },
    { 'f', mode = { 'n', 'o', 'x' } },
    { 's', '<Plug>(leap)', mode = { 'o', 'x' }, desc = 'leap' },
    { 's', '<Plug>(leap-anywhere)', desc = 'leap' },
    { 't', mode = { 'n', 'o', 'x' } },
    {
      'S',
      function() require('leap').leap { inputlen = 1, windows = { vim.api.nvim_get_current_win() } } end,
      mode = { 'o', 'x' },
      desc = 'leap',
    },
    {
      'S',
      function() require('leap').leap { inputlen = 1, windows = require('leap.util').get_focusable_windows() } end,
      desc = 'leap',
    },
  },
  config = function()
    require('leap').opts.preview = function() return false end
    require('leap').opts.on_beacons = function(targets, _, _)
      for _, t in ipairs(targets) do
        if t.label and t.beacon then t.beacon[1] = 0 end
      end
      return true
    end

    local ft_args = function(key_specific_args)
      local common_args = {
        inputlen = 1,
        inclusive = true,
        opts = {
          labels = {},
          safe_labels = vim.fn.mode(1):match 'o' and {} or nil,
        },
      }
      return vim.tbl_deep_extend('keep', common_args, key_specific_args)
    end

    for key, key_specific_args in pairs {
      F = { backward = true, opts = require('leap.user').with_traversal_keys(',', ';') },
      T = { backward = true, offset = 1, opts = require('leap.user').with_traversal_keys(',', ';') },
      f = { opts = require('leap.user').with_traversal_keys(';', ',') },
      t = { offset = -1, opts = require('leap.user').with_traversal_keys(';', ',') },
    } do
      vim.keymap.set(
        { 'n', 'x', 'o' },
        key,
        function() require('leap').leap(ft_args(key_specific_args)) end,
        { desc = 'leap ' .. key }
      )
    end
  end,
}
