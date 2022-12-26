return {
  'gbprod/substitute.nvim',
  requires = 'tpope/vim-abolish',
  config = function()
    require('substitute').setup {
      range = {
        prefix = 'S',
      },
    }
    vim.keymap.set('n', 'cx', require('substitute.exchange').operator)
    vim.keymap.set('n', 'cxx', require('substitute.exchange').line)
    vim.keymap.set('x', 'X', require('substitute.exchange').visual)
    vim.keymap.set('n', 'gR', require('substitute').eol)
    vim.keymap.set('n', 'gr', require('substitute').operator)
    vim.keymap.set('n', 'grr', require('substitute').line)
    vim.keymap.set('x', 'gr', require('substitute').visual)
    vim.keymap.set('n', 'gs', function() require('substitute.range').operator { motion1 = 'iw' } end)
    vim.keymap.set('n', 'gss', function() require('substitute.range').operator { motion1 = 'iw', motion2 = '_' } end)
    vim.keymap.set('x', 'gs', require('substitute.range').visual)
  end,
}
