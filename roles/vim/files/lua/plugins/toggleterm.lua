return {
  'akinsho/toggleterm.nvim',
  keys = {
    [[<c-\>]],
    {
      '-',
      function() require('toggleterm.terminal').Terminal:new({ cmd = 'ranger', count = 8 }):toggle() end,
    },
    {
      '<c-l>',
      function() require('toggleterm.terminal').Terminal:new({ cmd = 'lazygit', count = 9 }):toggle() end,
    },
  },
  opts = {
    direction = 'float',
    float_opts = {
      border = 'none',
      width = function() return vim.o.columns end,
      height = function() return vim.o.lines end,
    },
    open_mapping = [[<c-\>]],
  },
}
