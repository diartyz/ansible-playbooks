return {
  'numToStr/Comment.nvim',
  cmd = 'UnwrapComment',
  keys = {
    'gbc',
    'gcc',
    { 'gb', mode = 'x' },
    { 'gc', mode = 'x' },
  },
  config = function()
    require('Comment').setup()

    local ft = require 'Comment.ft'
    ft.gn = '#%s'

    local calculate = ft.calculate
    ft.calculate = function(ctx)
      local ok, parser = pcall(vim.treesitter.get_parser, vim.api.nvim_get_current_buf())
      if not ok or not parser then
        return ft.get(vim.bo.filetype, ctx.ctype)
      end
      return calculate(ctx)
    end

    local function unwrap_c_comment(opts)
      local s, e = opts.line1, opts.line2
      if opts.range < 2 then
        while s > 1 and not vim.fn.getline(s):match '^%s*/%*' do
          s = s - 1
        end
        while e < vim.api.nvim_buf_line_count(0) and not vim.fn.getline(e):match '%*/%s*$' do
          e = e + 1
        end
      end
      if not (vim.fn.getline(s):match '^%s*/%*' and vim.fn.getline(e):match '%*/%s*$') then
        return vim.notify('Not inside a /* ... */ block', vim.log.levels.WARN)
      end

      local lines = vim.api.nvim_buf_get_lines(0, s - 1, e, false)
      lines[1] = lines[1]:gsub('^%s*/%*%s?', '')
      lines[#lines] = lines[#lines]:gsub('%s*%*/%s*$', '')
      for i = 2, #lines - 1 do
        lines[i] = lines[i]:gsub('^%s*%*%s?', '')
      end
      if lines[1]:match '^%s*$' then
        table.remove(lines, 1)
      end
      if lines[#lines] and lines[#lines]:match '^%s*$' then
        table.remove(lines)
      end
      vim.api.nvim_buf_set_lines(0, s - 1, e, false, lines)
    end

    vim.api.nvim_create_user_command('UnwrapComment', unwrap_c_comment, { range = true })
  end,
}
