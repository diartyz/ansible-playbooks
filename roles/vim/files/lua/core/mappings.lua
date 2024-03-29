vim.api.nvim_create_user_command('E', 'edit $MYVIMRC', { nargs = 0 })
vim.api.nvim_create_user_command('R', 'update|source $MYVIMRC', { nargs = 0 })
vim.api.nvim_create_user_command('W', 'noautocmd update', { nargs = 0 })
vim.api.nvim_create_user_command(
  'OpenInVSCode',
  [[exe "silent !code '" . getcwd() . "' --goto '" . expand('%') . ":" . line('.') . ":" . col('.') . "'"]],
  { nargs = 0 }
)
vim.g.mapleader = ' '
vim.keymap.set('i', '<c-a>', '<c-o>I')
vim.keymap.set('i', '<c-e>', '<c-o>A')
vim.keymap.set('n', '<bs>', '<cmd>nohlsearch<cr>')
vim.keymap.set('n', '<c-h>', '<cmd>nohlsearch<cr>')
vim.keymap.set('n', '<leader><leader>q', '<cmd>qa!<cr>')
vim.keymap.set('n', '<leader><leader>s', '<cmd>x<cr>')
vim.keymap.set('n', '<leader>q', '<cmd>q<cr>')
vim.keymap.set('n', '<leader>s', '<cmd>update<cr>')
vim.keymap.set('n', '<leader>x', '<cmd>bd<cr>')
vim.keymap.set('n', 'cf', [[<cmd>let @+=expand('%')<cr>]])
vim.keymap.set('n', 'cp', [[<cmd>let @+=expand('%:p')<cr>]])
