return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  keys = {
    { "'1", function() require('harpoon'):list():select(1) end },
    { "'2", function() require('harpoon'):list():select(2) end },
    { "'3", function() require('harpoon'):list():select(3) end },
    { "'4", function() require('harpoon'):list():select(4) end },
    { "'5", function() require('harpoon'):list():select(5) end },
    { "'6", function() require('harpoon'):list():select(6) end },
    { "'7", function() require('harpoon'):list():select(7) end },
    { "'8", function() require('harpoon'):list():select(8) end },
    { "'9", function() require('harpoon'):list():select(9) end },
    { '<leader>o', function() require('harpoon').ui:toggle_quick_menu(require('harpoon'):list()) end },
    { 'mo', function() require('harpoon'):list():add() end },
  },
  config = true,
}
