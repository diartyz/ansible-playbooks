return {
  'ggandor/leap.nvim',
  keys = {
    { 'S', '<Plug>(leap)', mode = { 'n', 'o', 'x' } },
  },
  config = function()
    local leap = require 'leap'
    leap.opts.max_phase_one_targets = 0
    vim.api.nvim_set_hl(0, 'LeapBackdrop', { link = 'Comment' })
  end,
}
