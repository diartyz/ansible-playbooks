return {
  'akinsho/toggleterm.nvim',
  cmd = 'Blame',
  keys = {
    [[<c-\>]],
    {
      '+',
      function() require('toggleterm.terminal').Terminal:new({ cmd = 'yazi', count = 8 }):toggle() end,
      desc = 'yazi',
    },
    {
      '-',
      function() require('toggleterm.terminal').Terminal:new({ cmd = 'lazygit', count = 9 }):toggle() end,
      desc = 'lazygit',
    },
  },
  config = function()
    require('toggleterm').setup {
      direction = 'float',
      float_opts = {
        width = function() return vim.o.columns end,
        height = function() return vim.o.lines end,
      },
      open_mapping = [[<c-\>]],
    }

    vim.api.nvim_create_user_command('Blame', function(opts)
      local line1 = opts.line1
      local line2 = opts.line2
      local file = vim.api.nvim_buf_get_name(0)
      local root = vim.fs.root(0, '.git')
      if not root then return vim.notify('not in a git repo', vim.log.levels.WARN) end
      local range = line1 == line2 and ('%d,+1'):format(line1) or ('%d,%d'):format(line1, line2)
      local cmd = ('DELTA_PAGER="less -X" git -C %s log -n 5 -u -L %s:%s'):format(
        vim.fn.shellescape(root),
        range,
        vim.fn.shellescape(file)
      )
      require('toggleterm.terminal').Terminal:new({ cmd = cmd, count = 0 }):toggle()
    end, { nargs = 0, range = true, desc = 'git blame line' })

    vim.api.nvim_create_autocmd('TermEnter', {
      group = vim.api.nvim_create_augroup('set_no_hlsearch', { clear = true }),
      callback = function() vim.opt_local.hlsearch = false end,
    })
    vim.api.nvim_create_autocmd('TermLeave', {
      group = vim.api.nvim_create_augroup('set_hlsearch', { clear = true }),
      callback = function() vim.opt_local.hlsearch = true end,
    })
  end,
}
