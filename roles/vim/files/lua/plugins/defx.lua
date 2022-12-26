return {
  'Shougo/defx.nvim',
  run = ':UpdateRemotePlugins',
  requires = {
    'kristijanhusak/defx-git',
    'kristijanhusak/defx-icons',
  },
  config = function()
    vim.keymap.set('n', '<c-e>', [[<cmd>Defx -search_recursive=`expand('%:p')`<cr>]])
    vim.fn['defx#custom#option']('_', {
      columns = 'git:indent:icons:mark:filename:type',
      preview_width = 80,
      resume = 1,
      show_ignored_files = 1,
      split = 'vertical',
      vertical_preview = 1,
      winwidth = '39',
    })
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'defx',
      callback = function()
        vim.keymap.set('n', 'q', function() vim.fn['defx#call_async_action'] 'quit' end, { buffer = true })
        vim.keymap.set('n', '<c-e>', function() vim.fn['defx#call_async_action'] 'quit' end, { buffer = true })
        vim.keymap.set(
          'n',
          '<cr>',
          function() vim.fn['defx#call_async_action']('multi', { 'drop', 'quit' }) end,
          { buffer = true }
        )
        vim.keymap.set('n', 'h', function() vim.fn['defx#call_async_action'] 'close_tree' end, { buffer = true })
        vim.keymap.set('n', 'l', function()
          if vim.call 'defx#is_directory' then
            vim.fn['defx#call_async_action'] 'open_tree'
          else
            vim.fn['defx#call_async_action'] 'preview'
          end
        end, { buffer = true })
        vim.keymap.set('n', 'o', function() vim.fn['defx#call_async_action'] 'drop' end, { buffer = true })
        vim.keymap.set('n', 'p', function() vim.fn['defx#call_async_action'] 'paste' end, { buffer = true })
        vim.keymap.set('n', 'cc', function() vim.fn['defx#call_async_action'] 'rename' end, { buffer = true })
        vim.keymap.set('n', 'cp', function() vim.fn['defx#call_async_action'] 'yank_path' end, { buffer = true })
        vim.keymap.set('n', 'dd', function() vim.fn['defx#call_async_action'] 'move' end, { buffer = true })
        vim.keymap.set('n', 'yy', function() vim.fn['defx#call_async_action'] 'copy' end, { buffer = true })
        vim.keymap.set(
          'n',
          'D',
          function() vim.fn['defx#call_async_action']('remove_trash', { 'force' }) end,
          { buffer = true }
        )
        vim.keymap.set(
          'n',
          'M',
          function() vim.fn['defx#call_async_action'] 'new_multiple_files' end,
          { buffer = true }
        )
        vim.keymap.set('n', 'R', function()
          vim.api.nvim_command [[Defx -search_recursive=`expand('%:p')`]]
          vim.fn['defx#call_async_action'] 'redraw'
        end, { buffer = true })
        vim.keymap.set('n', 'v', function()
          vim.fn['defx#call_async_action'] 'toggle_select'
          vim.api.nvim_feedkeys('j', 'in', true)
        end, { buffer = true })
        vim.keymap.set('n', 'C', function() vim.fn['defx#call_async_action'] 'clear_select_all' end, { buffer = true })
        vim.keymap.set('n', 'V', function() vim.fn['defx#call_async_action'] 'toggle_select_all' end, { buffer = true })
      end,
    })
  end,
}
