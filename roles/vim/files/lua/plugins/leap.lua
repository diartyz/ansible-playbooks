return {
  'ggandor/leap.nvim',
  keys = {
    { 'F', mode = { 'n', 'o', 'x' } },
    { 'T', mode = { 'n', 'o', 'x' } },
    { 'f', mode = { 'n', 'o', 'x' } },
    { 't', mode = { 'n', 'o', 'x' } },
    { 's', '<Plug>(leap)', mode = { 'o', 'x' } },
    { 's', '<Plug>(leap-anywhere)' },
  },
  config = function()
    require('leap').opts.preview_filter = function() return false end
    require('leap').opts.on_beacons = function(targets, _, _)
      for _, t in ipairs(targets) do
        if t.label and t.beacon then t.beacon[1] = 0 end
      end
      return true
    end

    local function ft_args(key_specific_args)
      local common_args = {
        inputlen = 1,
        inclusive_op = true,
        opts = {
          labels = {},
          safe_labels = vim.fn.mode(1):match 'o' and {} or nil,
        },
      }
      return vim.tbl_deep_extend('keep', common_args, key_specific_args)
    end

    local leap = require('leap').leap
    local with_traversal_keys = require('leap.user').with_traversal_keys
    local feed_keys = require('core/utils').feed_keys
    local set_last_move = require('core/utils').set_last_move
    local f_repeat = function(repeat_opts)
      if repeat_opts.forward then
        feed_keys 'f<cr>'
      else
        feed_keys 'F<cr>'
      end
    end
    local t_repeat = function(repeat_opts)
      if repeat_opts.forward then
        feed_keys 't<cr>'
      else
        feed_keys 'T<cr>'
      end
    end

    vim.keymap.set({ 'n', 'x', 'o' }, 'F', function()
      leap(ft_args { opts = with_traversal_keys(',', ';'), backward = true })
      set_last_move(f_repeat)
    end, { desc = 'leap F' })
    vim.keymap.set({ 'n', 'x', 'o' }, 'T', function()
      leap(ft_args { opts = with_traversal_keys(',', ';'), backward = true, offset = 1 })
      set_last_move(t_repeat)
    end, { desc = 'leap T' })
    vim.keymap.set({ 'n', 'x', 'o' }, 'f', function()
      leap(ft_args { opts = with_traversal_keys(';', ',') })
      set_last_move(f_repeat)
    end, { desc = 'leap f' })
    vim.keymap.set({ 'n', 'x', 'o' }, 't', function()
      leap(ft_args { opts = with_traversal_keys(';', ','), offset = -1 })
      set_last_move(t_repeat)
    end, { desc = 'leap t' })
  end,
}
