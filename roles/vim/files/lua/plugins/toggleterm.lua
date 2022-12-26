return {
  'akinsho/toggleterm.nvim',
  config = function()
    require('toggleterm').setup {
      direction = 'float',
      float_opts = {
        border = 'none',
        width = function() return vim.o.columns end,
        height = function() return vim.o.lines end,
      },
      open_mapping = [[<c-\>]],
    }
    local Terminal = require('toggleterm.terminal').Terminal
    local lazygit = Terminal:new {
      cmd = 'lazygit',
      count = 9,
    }
    local ranger = Terminal:new {
      cmd = 'ranger',
      count = 8,
    }
    vim.keymap.set('n', '-', function() ranger:toggle() end)
    vim.keymap.set('n', '<c-l>', function() lazygit:toggle() end)
  end,
}
