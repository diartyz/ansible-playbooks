return {
  'tanvirtin/vgit.nvim',
  dependencies = 'nvim-lua/plenary.nvim',
  keys = '<leader>hg',
  opts = {
    keymaps = {
      ['n ]h'] = 'hunk_down',
      ['n [h'] = 'hunk_up',
      ['n <leader>hg'] = 'buffer_history_preview',
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
  },
}
