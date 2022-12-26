vim.api.nvim_create_user_command('E', 'edit $MYVIMRC', { nargs = 0 })
vim.api.nvim_create_user_command('Jq', [[%!jq '--sort-keys']], { nargs = 0 })
vim.api.nvim_create_user_command('R', 'update|source $MYVIMRC', { nargs = 0 })
vim.api.nvim_create_user_command('W', 'noautocmd update', { nargs = 0 })
vim.api.nvim_create_user_command(
  'OpenInVSCode',
  [[exe "silent !code '" . getcwd() . "' --goto '" . expand('%') . ":" . line('.') . ":" . col('.') . "'"]],
  { nargs = 0 }
)
vim.g.mapleader = ' '
vim.keymap.set('n', '<bs>', '<cmd>nohlsearch<cr>')
vim.keymap.set('n', '<c-h>', '<cmd>nohlsearch<cr>')
vim.keymap.set('n', '<leader><leader>q', '<cmd>qall<cr>')
vim.keymap.set('n', '<leader><leader>s', '<cmd>wall<cr>')
vim.keymap.set('n', '<leader>q', '<cmd>q<cr>')
vim.keymap.set('n', '<leader>s', '<cmd>update<cr>')
vim.keymap.set('n', '<leader>x', '<cmd>bd<cr>')
vim.keymap.set('n', 'cf', [[<cmd>let @+=expand('%:t')<cr>]])
vim.keymap.set('n', 'cp', [[<cmd>let @+=expand('%') . ' ' . line('.') . ':' . col('.')<cr>]])
