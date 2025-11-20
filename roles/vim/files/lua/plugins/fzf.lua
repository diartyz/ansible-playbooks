return {
  'ibhagwan/fzf-lua',
  dependencies = 'nvim-tree/nvim-web-devicons',
  cmd = 'FzfLua',
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
