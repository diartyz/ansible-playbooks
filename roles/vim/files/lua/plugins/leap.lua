return {
  'ggandor/leap.nvim',
  keys = {
    { 's', '<Plug>(leap)', mode = { 'o', 'x' } },
    { 's', '<Plug>(leap-anywhere)' },
  },
  config = function()
    require('leap').opts.preview_filter = function() return false end
  end,
}
