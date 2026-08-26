return {
  'ibhagwan/fzf-lua',
  dependencies = 'nvim-tree/nvim-web-devicons',
  cmd = 'FzfLua',
  keys = {
    { '<c-p>', function() require('fzf-lua').files() end, desc = 'search files' },
    { '<leader>:', function() require('fzf-lua').command_history() end, desc = 'search command history' },
    { '<leader>a', function() require('fzf-lua').buffers() end, desc = 'search buffers' },
  },
  config = function()
    require('fzf-lua').setup {
      buffers = {
        actions = {
          ['ctrl-d'] = { fn = require('fzf-lua').actions.buf_del, reload = true },
        },
      },
      files = {
        fd_opts = [[--type f --color=never --hidden --exclude .cache --exclude .git --exclude out]],
        find_opts = [[-type f -not -path '*/\.cache/*' -not -path '*/\.git/*' -not -path '*/out/*' -printf '%P\n']],
        rg_opts = [[--files --color=never --hidden -g "!.cache" -g "!.git" -g "!out"]],
        search_paths = vim.g.fzf_dirs,
      },
      fzf_opts = {
        ['--history'] = vim.fn.stdpath 'data' .. '/fzf-lua-history',
      },
      keymap = {
        fzf = {
          ['ctrl-j'] = 'next-history',
          ['ctrl-k'] = 'prev-history',
          ['ctrl-n'] = 'down',
          ['ctrl-p'] = 'up',
        },
      },
      winopts = {
        preview = {
          layout = 'vertical',
        },
      },
    }
  end,
}
