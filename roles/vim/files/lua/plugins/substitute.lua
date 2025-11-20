return {
  'gbprod/substitute.nvim',
  dependencies = { 'tpope/vim-abolish', keys = 'cr' },
  keys = {
    { 'X', function() require('substitute.exchange').visual() end, mode = 'x', desc = 'exchange' },
    { 'cx', function() require('substitute.exchange').operator() end, desc = 'exchange' },
    { 'cxx', function() require('substitute.exchange').line() end, desc = 'exchange' },
    { 'gr', function() require('substitute').operator() end, desc = 'paste' },
    { 'grr', function() require('substitute').line() end, desc = 'paste' },
    { 'gr', function() require('substitute').visual() end, mode = 'x', desc = 'paste' },
    { 'gs', function() require('core.utils').feed_keys ':S///g<Left><Left><Left>' end, mode = 'x', desc = 'replace' },
    { 'gs', function() require('substitute.range').operator { subject = { motion = 'iw' } } end, desc = 'replace' },
    {
      'gss',
      function() require('substitute.range').operator { subject = { motion = 'iw' }, range = { motion = '_' } } end,
      desc = 'replace',
    },
  },
  opts = {
    range = {
      prefix = 'S',
    },
  },
}
