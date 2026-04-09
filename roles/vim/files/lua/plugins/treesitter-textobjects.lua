return {
  'nvim-treesitter/nvim-treesitter-textobjects',
  dependencies = 'nvim-treesitter/nvim-treesitter',
  keys = {
    { '[', mode = { 'n', 'o', 'x' } },
    { ']', mode = { 'n', 'o', 'x' } },
    { 'af', mode = { 'o', 'x' } },
    { 'if', mode = { 'o', 'x' } },
  },
  config = function()
    local move = require 'nvim-treesitter-textobjects.move'
    local select = require 'nvim-treesitter-textobjects.select'
    local swap = require 'nvim-treesitter-textobjects.swap'

    -- move
    vim.keymap.set({ 'n', 'x', 'o' }, ']f', function() move.goto_next_start '@function.outer' end)
    vim.keymap.set({ 'n', 'x', 'o' }, ']a', function() move.goto_next_start '@parameter.inner' end)
    vim.keymap.set({ 'n', 'x', 'o' }, '[f', function() move.goto_previous_end '@function.outer' end)
    vim.keymap.set({ 'n', 'x', 'o' }, '[a', function() move.goto_previous_end '@parameter.inner' end)

    -- select
    vim.keymap.set({ 'x', 'o' }, 'af', function() select.select_textobject '@function.outer' end)
    vim.keymap.set({ 'x', 'o' }, 'if', function() select.select_textobject '@function.inner' end)

    -- swap
    vim.keymap.set('n', '][', function() swap.swap_next '@parameter.inner' end)
    vim.keymap.set('n', '[]', function() swap.swap_previous '@parameter.inner' end)
  end,
}
