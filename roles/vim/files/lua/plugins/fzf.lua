return {
  'ibhagwan/fzf-lua',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  cmd = { 'FzfLua' },
  keys = {
    { '<c-p>', function() require('fzf-lua').files() end },
    { '<leader>a', function() require('fzf-lua').buffers() end },
    { '<leader>m', function() require('fzf-lua').marks() end },
    {
      '<leader>t',
      function()
        require('fzf-lua').live_grep_resume {
          cmd = 'rg --line-number --hidden ' .. (vim.g.fzf_search_path or '') .. ' -g "!.git"',
        }
      end,
    },
    {
      '<leader>p',
      function()
        require('fzf-lua').files { cmd = 'rg --files --hidden ' .. (vim.g.fzf_search_path or '') .. ' -g "!.git"' }
      end,
    },
  },
  config = function()
    require('fzf-lua').setup {
      winopts = {
        preview = {
          layout = 'vertical',
        },
      },
      files = {
        fd_opts = [[--color=never --type f --hidden --follow --exclude .cache --exclude .git --exclude out]],
        find_opts = [[-type f -not -path '*/\.cache/*' -not -path '*/\.git/*' -not -path '*/out/*' -printf '%P\n']],
        rg_opts = [[--color=never --files --hidden --follow -g "!.git"]],
      },
    }
  end,
}
