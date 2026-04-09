return {
  'stevearc/conform.nvim',
  cmd = 'ConformInfo',
  event = 'BufWritePre',
  keys = {
    {
      'gq',
      function()
        require('conform').format({ async = true }, function(err)
          if err then return end
          local mode = vim.api.nvim_get_mode().mode
          if vim.startswith(string.lower(mode), 'v') then require('core.utils').feed_keys '<esc>' end
        end)
      end,
      mode = { 'n', 'x' },
      desc = 'format',
    },
  },
  config = function()
    require('conform').setup {
      default_format_opts = {
        lsp_format = 'fallback',
      },
      formatters_by_ft = {
        gn = { 'gn' },
        lua = { 'stylua' },
        python = function(bufnr)
          if require('conform').get_formatter_info('ruff_format', bufnr).available then
            return { 'ruff_format' }
          else
            return { 'isort', 'black' }
          end
        end,
      },
      formatters = {
        gn = { command = vim.g.gn_path or 'gn' },
        stylua = {
          append_args = {
            '--call-parentheses',
            'None',
            '--collapse-simple-statement',
            'Always',
            '--indent-type',
            'Spaces',
            '--indent-width',
            '2',
            '--quote-style',
            'AutoPreferSingle',
          },
        },
      },
    }

    local conform = require 'conform'
    local is_module_available = require('core.utils').is_module_available
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = vim.api.nvim_create_augroup('format', { clear = true }),
      callback = function(args)
        local hunks = is_module_available 'gitsigns' and require('gitsigns').get_hunks(0) or nil
        if not hunks then
          conform.format { bufnr = args.buf }
          return
        end
        for i = #hunks, 1, -1 do
          local hunk = hunks[i]
          if hunk ~= nil and hunk.type ~= 'delete' then
            local start = hunk.added.start
            local last = start + hunk.added.count
            local last_hunk_line = vim.api.nvim_buf_get_lines(0, last - 2, last - 1, true)[1]
            conform.format {
              bufnr = args.buf,
              range = {
                start = { start, 0 },
                ['end'] = { last - 1, last_hunk_line:len() },
              },
            }
          end
        end
      end,
    })
  end,
}
