return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    dependencies = 'nvim-treesitter/nvim-treesitter-textobjects',
    event = 'VeryLazy',
    main = 'nvim-treesitter.configs',
    opts = {
      auto_install = true,
      ensure_installed = {
        'cpp',
        'javascript',
        'lua',
        'regex',
        'tsx',
        'typescript',
      },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      textobjects = {
        move = {
          enable = true,
          goto_next_start = {
            [']]'] = '@function.outer',
          },
          goto_next_end = {
            [']['] = '@function.outer',
          },
          goto_previous_start = {
            ['[['] = '@function.outer',
          },
          goto_previous_end = {
            ['[]'] = '@function.outer',
          },
          goto_next = {
            [']d'] = { query = { '@conditional.*', '@loop.outer' } },
          },
          goto_previous = {
            ['[d'] = { query = { '@conditional.*', '@loop.outer' } },
          },
        },
        select = {
          enable = true,
          keymaps = {
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
          },
        },
      },
    },
  },
}
