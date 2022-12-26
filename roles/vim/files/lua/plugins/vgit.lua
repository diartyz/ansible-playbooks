return {
  'tanvirtin/vgit.nvim',
  requires = 'nvim-lua/plenary.nvim',
  config = function()
    require('vgit').setup {
      keymaps = {
        ['n ]h'] = 'hunk_down',
        ['n [h'] = 'hunk_up',
        ['n <leader>hg'] = 'buffer_history_preview',
        ['n <leader>ha'] = 'project_diff_preview',
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
