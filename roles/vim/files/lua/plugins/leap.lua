return {
  'ggandor/leap.nvim',
  keys = {
    {
      's',
      function() require('leap').leap { target_windows = require('leap.user').get_focusable_windows() } end,
      mode = { 'n', 'o', 'x' },
    },
  },
  config = function()
    require('leap').opts.preview_filter = function() return false end
    vim.api.nvim_set_hl(0, 'LeapBackdrop', { link = 'Comment' })
  end,
}
