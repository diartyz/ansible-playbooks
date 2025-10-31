-- general
vim.opt.clipboard = { 'unnamed', 'unnamedplus' }
-- vim.opt.exrc = true
-- vim.opt.fileencodings = { 'utf-8', 'gb2312' }
vim.opt.swapfile = false
vim.opt.undodir = '/tmp/nvim'
vim.opt.undofile = true
-- vim.opt.updatetime = 300
-- vim.opt.wildignore = { '*/.cache/*', '*/dist/*', '*/node_modules/*' }
-- if vim.fn.executable 'clip.exe' then
--   vim.g.clipboard = {
--     name = 'WslClipboard',
--     copy = {
--       ['+'] = 'clip.exe',
--       ['*'] = 'clip.exe',
--     },
--   }
-- end

-- search & tab
vim.opt.breakindent = true
vim.opt.expandtab = true
vim.opt.ignorecase = true
vim.opt.shiftround = true
vim.opt.shiftwidth = 0
vim.opt.tabstop = 2

-- mappings
vim.api.nvim_create_user_command('E', 'edit $MYVIMRC', { nargs = 0 })
vim.api.nvim_create_user_command('R', 'update|source $MYVIMRC', { nargs = 0 })
vim.api.nvim_create_user_command('Q', 'qa!', { nargs = 0 })
vim.api.nvim_create_user_command('W', 'noautocmd wall', { nargs = 0 })
vim.api.nvim_create_user_command(
  'Code',
  [[exe "silent !code '" . getcwd() . "' --goto '" . expand('%') . ":" . line('.') . ":" . col('.') . "'"]],
  { nargs = 0 }
)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.keymap.set('i', '<c-a>', '<c-o>I')
vim.keymap.set('i', '<c-e>', '<c-o>A')
vim.keymap.set('n', '<bs>', '<cmd>nohlsearch|match none<cr>')
vim.keymap.set('n', '<c-h>', '<cmd>nohlsearch|match none<cr>')
vim.keymap.set('n', '<leader><leader>q', '<cmd>q!<cr>')
vim.keymap.set('n', '<leader><leader>s', '<cmd>noautocmd update<cr>')
vim.keymap.set('n', '<leader>m', ':match IncSearch /\\<<c-r><c-w>\\>/<cr>')
vim.keymap.set('n', '<leader>q', '<cmd>q<cr>')
vim.keymap.set('n', '<leader>s', '<cmd>update<cr>')
vim.keymap.set('n', '<leader>x', '<cmd>bdelete<cr>')
vim.keymap.set('n', 'cp', [[<cmd>let @+=expand('%:p')<cr>]])
vim.keymap.set('n', 'cy', [[<cmd>let @+=expand('%')<cr>]])
vim.keymap.set({ 'n', 'x' }, '$', 'g_')
vim.keymap.set({ 'n', 'x' }, 'g_', '$')
vim.keymap.set({ 'n', 'x' }, '0', '^')
vim.keymap.set({ 'n', 'x' }, '^', '0')
if vim.fn.has 'nvim-0.11' == 1 then
  vim.keymap.del('n', 'gO')
  vim.keymap.del('n', 'gri')
  vim.keymap.del('n', 'grn')
  vim.keymap.del('n', 'grr')
  vim.keymap.del({ 'n', 'x' }, 'gra')
end

-- syntax
-- vim.cmd 'syntax off'
-- vim.treesitter.language.register('bash', 'zsh')
vim.filetype.add {
  extension = {
    ets = 'typescript',
  },
}

-- ui
vim.opt.cmdheight = 0
vim.opt.colorcolumn = { 80, 120 }
vim.opt.cursorline = true
vim.opt.jumpoptions = 'stack'
vim.opt.laststatus = 0
vim.opt.number = true
vim.opt.termguicolors = true
vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('highlight_yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank {
      higroup = 'Visual',
      timeout = 300,
    }
  end,
})

local load_local_config = require('core/utils').load_local_config
local load_plugins = require 'core/lazy'

load_local_config 'nvim.lua'
load_plugins {
  -- coding
  require 'plugins/comment',
  require 'plugins/indent-object',
  require 'plugins/leap',
  require 'plugins/neogen',
  -- require 'plugins/sort-json',
  require 'plugins/substitute',
  require 'plugins/switch',
  require 'plugins/targets',
  require 'plugins/text-case',
  require 'plugins/textobj-entire',
  require 'plugins/treesitter-textobjects',
  require 'plugins/unimpaired',
  require 'plugins/visual-multi',
  { 'abecodes/tabout.nvim', dependencies = 'nvim-treesitter/nvim-treesitter', event = 'InsertEnter', config = true },
  -- { 'axelvc/template-string.nvim', event = 'InsertEnter', opts = { remove_template_string = true } },
  { 'chaoren/vim-wordmotion', event = 'VeryLazy', init = function() vim.g.wordmotion_prefix = '<leader>' end },
  -- { 'diartyz/vim-utils', event = 'VeryLazy' },
  -- { 'gcmt/wildfire.vim', keys = '<enter>' },
  { 'inkarkat/vim-AdvancedSorters', dependencies = 'inkarkat/vim-ingo-library', cmd = 'SortRangesByHeader' },
  { 'inkarkat/vim-visualrepeat', keys = { { '.', mode = 'x' } } },
  { 'junegunn/vim-easy-align', keys = { { 'ga', '<plug>(EasyAlign)', mode = { 'n', 'x' } } } },
  { 'tpope/vim-sleuth' },
  { 'tpope/vim-surround', dependencies = 'tpope/vim-repeat', event = 'VeryLazy' },
  -- { 'windwp/nvim-ts-autotag', dependencies = 'nvim-treesitter/nvim-treesitter', event = 'InsertEnter', config = true },

  -- editor
  require 'plugins/ctrlsf',
  require 'plugins/far',
  require 'plugins/fzf',
  require 'plugins/harpoon',
  require 'plugins/session',
  require 'plugins/telescope',
  require 'plugins/todo',
  require 'plugins/tree',
  require 'plugins/trouble',
  { 'andymass/vim-matchup', keys = { { '%', mode = { 'n', 'o', 'x' } } }, config = true },

  -- intelligence
  require 'plugins/cmp',
  require 'plugins/codecompanion',
  require 'plugins/copilot',
  require 'plugins/lexima',
  require 'plugins/lsp',
  require 'plugins/null-ls',
  -- require 'plugins/tabnine',
  { 'antosha417/nvim-lsp-file-operations', dependencies = 'nvim-lua/plenary.nvim', event = 'LspAttach', config = true },
  { 'j-hui/fidget.nvim', event = 'LspAttach', opts = { notification = { window = { winblend = 0 } } } },
  { 'ray-x/lsp_signature.nvim', event = 'LspAttach', config = true },

  -- ui
  require 'plugins/bufferline',
  require 'plugins/dropbar',
  require 'plugins/everforest',
  require 'plugins/gitsigns',
  require 'plugins/indent-blankline',
  require 'plugins/lualine',
  require 'plugins/noice',
  require 'plugins/treesitter',
  require 'plugins/ufo',
  { 'kevinhwang91/nvim-bqf', ft = 'qf' },
  -- { 'ntpeters/vim-better-whitespace', event = 'VeryLazy' },
  -- { 'sheerun/vim-polyglot', config = function() vim.g.vim_markdown_no_default_key_mappings = 1 end },
  { 'stevearc/dressing.nvim', event = 'VeryLazy', config = true },

  -- util
  -- require 'plugins/close-buffers',
  require 'plugins/fugitive',
  require 'plugins/markdown-preview',
  require 'plugins/neoscroll',
  -- require 'plugins/osc52',
  require 'plugins/profile',
  require 'plugins/sniprun',
  require 'plugins/toggleterm',
  require 'plugins/undotree',
  require 'plugins/vgit',
  { 'dstein64/vim-startuptime', cmd = 'StartupTime' },
  { 'folke/which-key.nvim', cmd = 'WhichKey', opts = { delay = 300 } },
  { 'lambdalisue/suda.vim', cmd = { 'SudaRead', 'SudaWrite' } },
  { 'wsdjeg/vim-fetch' },
}
