return {
  'itchyny/lightline.vim',
  requires = 'mengelbrecht/lightline-bufferline',
  config = function()
    vim.g.lightline = {
      colorscheme = 'everforest',
      active = {
        left = {
          { 'mode', 'paste' },
          { 'readonly', 'filename', 'modified' },
          { 'coc_status' },
        },
      },
      tabline = {
        left = {
          { 'buffers' },
        },
        right = {
          {},
        },
      },
      component_expand = {
        buffers = 'lightline#bufferline#buffers',
      },
      component_type = {
        buffers = 'tabsel',
      },
      component_raw = {
        buffers = 1,
      },
      component_function = {
        coc_status = 'coc#status',
      },
    }
    vim.g['lightline#bufferline#clickable'] = 1
    vim.g['lightline#bufferline#shorten_path'] = 0
    vim.g['lightline#bufferline#show_number'] = 2
    vim.keymap.set('n', '<leader>0', '<plug>lightline#bufferline#go(10)')
    vim.keymap.set('n', '<leader>1', '<plug>lightline#bufferline#go(1)')
    vim.keymap.set('n', '<leader>2', '<plug>lightline#bufferline#go(2)')
    vim.keymap.set('n', '<leader>3', '<plug>lightline#bufferline#go(3)')
    vim.keymap.set('n', '<leader>4', '<plug>lightline#bufferline#go(4)')
    vim.keymap.set('n', '<leader>5', '<plug>lightline#bufferline#go(5)')
    vim.keymap.set('n', '<leader>6', '<plug>lightline#bufferline#go(6)')
    vim.keymap.set('n', '<leader>7', '<plug>lightline#bufferline#go(7)')
    vim.keymap.set('n', '<leader>8', '<plug>lightline#bufferline#go(8)')
    vim.keymap.set('n', '<leader>9', '<plug>lightline#bufferline#go(9)')
  end,
}
