return {
  'gbprod/substitute.nvim',
  dependencies = 'tpope/vim-abolish',
  keys = {
    { 'cx', function() require('substitute.exchange').operator() end },
    { 'cxx', function() require('substitute.exchange').line() end },
    { 'X', function() require('substitute.exchange').visual() end, mode = 'v' },
    { 'gR', function() require('substitute').eol() end },
    { 'gr', function() require('substitute').operator() end },
    { 'grr', function() require('substitute').line() end },
    { 'gr', function() require('substitute').visual() end, mode = 'v' },
    { 'gs', function() require('substitute.range').operator { motion1 = 'iw' } end },
    { 'gss', function() require('substitute.range').operator { motion1 = 'iw', motion2 = '_' } end },
    {
      'gs',
      function()
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(':S///g<Left><Left><Left>', true, false, true), 'mi', true)
      end,
      mode = 'v',
    },
  },
  opts = {
    range = {
      prefix = 'S',
    },
  },
}
