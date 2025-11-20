return {
  'Bekaboo/dropbar.nvim',
  event = 'VeryLazy',
  dependencies = { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  config = function()
    require('dropbar').setup {
      bar = {
        sources = function(buf, _)
          local sources = require 'dropbar.sources'
          local utils = require 'dropbar.utils'
          if vim.bo[buf].ft == 'markdown' then return { sources.markdown } end
          if vim.bo[buf].buftype == 'terminal' then return { sources.terminal } end
          return { utils.source.fallback { sources.lsp, sources.treesitter } }
        end,
      },
      menu = {
        keymaps = {
          ['h'] = '<c-w>c',
          ['l'] = function()
            local menu_utils = require 'dropbar.utils.menu'
            local menu = menu_utils.get_current()
            if not menu then return end
            local row = vim.api.nvim_win_get_cursor(menu.win)[1]
            local component = menu.entries[row]:first_clickable()
            if component then menu:click_on(component, nil, 1, 'l') end
          end,
          ['o'] = function()
            local menu_utils = require 'dropbar.utils.menu'
            local menu = menu_utils.get_current()
            if not menu then return end
            local cursor = vim.api.nvim_win_get_cursor(menu.win)
            local entry = menu.entries[cursor[1]]
            local component = entry:first_clickable(entry.padding.left + entry.components[1]:bytewidth())
            if component then menu:click_on(component, nil, 1, 'l') end
          end,
        },
      },
      icons = {
        ui = {
          menu = { separator = '' },
        },
      },
    }

    local dropbar_api = require 'dropbar.api'
    vim.keymap.set('n', '<leader>;', dropbar_api.pick, { desc = 'dropbar.pick' })
    vim.keymap.set('n', 'gz', dropbar_api.goto_context_start, { desc = 'dropbar.goto_context_start' })
  end,
}
