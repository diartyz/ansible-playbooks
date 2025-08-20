return {
  'tanvirtin/vgit.nvim',
  dependencies = 'nvim-lua/plenary.nvim',
  event = 'VeryLazy',
  config = function()
    local vgit = require 'vgit'
    local next_hunk_repeat, prev_hunk_repeat =
      require('core/utils').make_repeatable_move_pair(vgit.hunk_down, vgit.hunk_up)

    vgit.setup {
      keymaps = {
        ['n ]c'] = next_hunk_repeat,
        ['n [c'] = prev_hunk_repeat,
        ['n <leader>gb'] = 'buffer_blame_preview',
        ['n <leader>gh'] = 'buffer_history_preview',
        ['n ga'] = 'buffer_conflict_accept_both',
        ['n gb'] = 'buffer_conflict_accept_incoming',
        ['n gc'] = 'buffer_conflict_accept_current',
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
