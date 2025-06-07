return {
  'ibhagwan/fzf-lua',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  cmd = { 'FzfLua' },
  keys = {
    { '<c-p>', function() require('fzf-lua').files() end },
    {
      '<leader>p',
      function()
        if vim.g.fzf_search_path then
          require('fzf-lua').files {
            cmd = 'rg --files --color=never --hidden ' .. vim.g.fzf_search_path .. ' -g "!.git"',
          }
        else
          require('fzf-lua').files()
        end
      end,
    },
    {
      '<leader>/',
      function()
        if vim.g.fzf_search_path then
          require('fzf-lua').live_grep_resume {
            cmd = 'rg --line-number --color=never --hidden ' .. vim.g.fzf_search_path .. ' -g "!.git"',
          }
        else
          require('fzf-lua').live_grep_resume()
        end
      end,
    },
  },
  config = function()
    require('fzf-lua').setup {
      files = {
        fd_opts = [[--type f --color=never --hidden --exclude .cache --exclude .git --exclude out]],
        find_opts = [[-type f -not -path '*/\.cache/*' -not -path '*/\.git/*' -not -path '*/out/*' -printf '%P\n']],
        rg_opts = [[--files --color=never --hidden -g "!.cache" -g "!.git" -g "!out"]],
      },
      fzf_opts = {
        ['--history'] = vim.fn.stdpath 'data' .. '/fzf-lua-history',
      },
      winopts = {
        preview = {
          layout = 'vertical',
        },
      },
    }
  end,
}
