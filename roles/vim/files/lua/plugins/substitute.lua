return {
  'gbprod/substitute.nvim',
  dependencies = { 'tpope/vim-abolish', keys = 'cr' },
  keys = {
    { 'X', function() require('substitute.exchange').visual() end, mode = 'x' },
    { 'cx', function() require('substitute.exchange').operator() end },
    { 'cxx', function() require('substitute.exchange').line() end },
    { 'gr', function() require('substitute').operator() end },
    { 'grr', function() require('substitute').line() end },
    { 'gr', function() require('substitute').visual() end, mode = 'x' },
    { 'gs', function() require('substitute.range').operator { subject = { motion = 'iw' } } end },
    {
      'gss',
      function() require('substitute.range').operator { subject = { motion = 'iw' }, range = { motion = '_' } } end,
    },
    {
      'gs',
      function()
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(':S///g<Left><Left><Left>', true, false, true), 'mi', true)
      end,
      mode = 'x',
    },
  },
  opts = {
    range = {
      prefix = 'S',
    },
  },
}
