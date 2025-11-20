return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = 'nvim-lua/plenary.nvim',
  keys = {
    { "'1", function() require('harpoon'):list():select(1) end, desc = 'harpoon' },
    { "'2", function() require('harpoon'):list():select(2) end, desc = 'harpoon' },
    { "'3", function() require('harpoon'):list():select(3) end, desc = 'harpoon' },
    { "'4", function() require('harpoon'):list():select(4) end, desc = 'harpoon' },
    { "'5", function() require('harpoon'):list():select(5) end, desc = 'harpoon' },
    { "'6", function() require('harpoon'):list():select(6) end, desc = 'harpoon' },
    { "'7", function() require('harpoon'):list():select(7) end, desc = 'harpoon' },
    { "'8", function() require('harpoon'):list():select(8) end, desc = 'harpoon' },
    { "'9", function() require('harpoon'):list():select(9) end, desc = 'harpoon' },
    { 'mo', function() require('harpoon'):list():add() end, desc = 'harpoon add' },
    {
      '<leader>o',
      function() require('harpoon').ui:toggle_quick_menu(require('harpoon'):list()) end,
      desc = 'harpoon list',
    },
  },
  config = true,
}
