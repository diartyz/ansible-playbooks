return {
  'ggandor/leap.nvim',
  keys = {
    { 'F', mode = { 'n', 'x', 'o' } },
    { 'T', mode = { 'n', 'x', 'o' } },
    { 'f', mode = { 'n', 'x', 'o' } },
    { 't', mode = { 'n', 'x', 'o' } },
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
    local opts = with_traversal_keys(';', ',')

    vim.keymap.set({ 'n', 'x', 'o' }, 'F', function() leap(ft_args { opts = opts, backward = true }) end)
    vim.keymap.set({ 'n', 'x', 'o' }, 'T', function() leap(ft_args { opts = opts, backward = true, offset = -1 }) end)
    vim.keymap.set({ 'n', 'x', 'o' }, 'f', function() leap(ft_args { opts = opts }) end)
    vim.keymap.set({ 'n', 'x', 'o' }, 't', function() leap(ft_args { opts = opts, offset = -1 }) end)
  end,
}
