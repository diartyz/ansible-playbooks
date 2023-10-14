return {
  'tanvirtin/vgit.nvim',
  dependencies = 'nvim-lua/plenary.nvim',
  cmd = 'VGit',
  keys = '<leader>gh',
  config = function()
    local vgit = require 'vgit'
    local isModuleAvailable = require('core/utils').isModuleAvailable
    local next_hunk_repeat, prev_hunk_repeat =
      isModuleAvailable 'nvim-treesitter.textobjects.repeatable_move' and require(
        'nvim-treesitter.textobjects.repeatable_move'
      ).make_repeatable_move_pair(vgit.hunk_down, vgit.hunk_up) or vgit.hunk_down,
      vgit.hunk_up

    vgit.setup {
      keymaps = {
        ['n ]h'] = next_hunk_repeat,
        ['n [h'] = prev_hunk_repeat,
        ['n <leader>gh'] = 'buffer_history_preview',
      },
      settings = {
        live_blame = {
          enabled = false,
        },
        live_gutter = {
          enabled = false,
        },
        authorship_code_lens = {
          enabled = false,
        },
        signs = {
          definitions = {
            GitSignsAdd = {
              text = '+',
            },
            GitSignsDelete = {
              text = '-',
            },
            GitSignsChange = {
              text = '~',
            },
          },
        },
      },
    }
  end,
}
