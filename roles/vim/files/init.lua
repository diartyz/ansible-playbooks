local load_plugins = require 'core/lazy'
local load_local_config = require 'core/local'

-- general
vim.opt.clipboard = { 'unnamed', 'unnamedplus' }
-- vim.opt.fileencodings = { 'utf-8', 'gb2312' }
vim.opt.foldlevel = 99
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt.foldmethod = 'expr'
vim.opt.swapfile = false
vim.opt.undodir = '/tmp/nvim'
vim.opt.undofile = true
-- vim.opt.updatetime = 300
-- vim.opt.wildignore = { '*/.cache/*', '*/dist/*', '*/node_modules/*' }

-- osc52
if os.getenv 'SSH_TTY' ~= nil then
  vim.g.clipboard = {
    name = 'OSC 52',
    copy = {
      ['+'] = require('vim.ui.clipboard.osc52').copy '+',
      ['*'] = require('vim.ui.clipboard.osc52').copy '*',
    },
    paste = {
      ['+'] = require('vim.ui.clipboard.osc52').paste '+',
      ['*'] = require('vim.ui.clipboard.osc52').paste '*',
    },
  }
end

-- search & tab
-- vim.g.markdown_recommended_style = false
vim.opt.expandtab = true
vim.opt.ignorecase = true
-- vim.opt.shiftround = true
vim.opt.shiftwidth = 0
vim.opt.tabstop = 2

-- mappings
vim.api.nvim_create_user_command('E', 'edit $MYVIMRC', { nargs = 0 })
vim.api.nvim_create_user_command('R', 'update|source $MYVIMRC', { nargs = 0 })
vim.api.nvim_create_user_command('W', 'noautocmd update', { nargs = 0 })
-- vim.api.nvim_create_user_command(
--   'OpenInVSCode',
--   [[exe "silent !code '" . getcwd() . "' --goto '" . expand('%') . ":" . line('.') . ":" . col('.') . "'"]],
--   { nargs = 0 }
-- )
vim.g.mapleader = ' '
vim.keymap.set('i', '<c-a>', '<c-o>I')
vim.keymap.set('i', '<c-e>', '<c-o>A')
vim.keymap.set('n', '<bs>', '<cmd>nohlsearch<cr>')
vim.keymap.set('n', '<c-h>', '<cmd>nohlsearch<cr>')
vim.keymap.set('n', '<leader><leader>q', '<cmd>qa!<cr>')
vim.keymap.set('n', '<leader><leader>s', '<cmd>noautocmd update<cr>')
vim.keymap.set('n', '<leader>q', '<cmd>q<cr>')
vim.keymap.set('n', '<leader>s', '<cmd>update<cr>')
vim.keymap.set('n', '[B', '<cmd>bfirst<cr>')
vim.keymap.set('n', ']B', '<cmd>blast<cr>')
vim.keymap.set('n', 'cf', [[<cmd>let @+=expand('%')<cr>]])
vim.keymap.set('n', 'cp', [[<cmd>let @+=expand('%:p')<cr>]])

-- syntax
vim.api.nvim_create_autocmd({ 'BufNew', 'BufNewFile', 'BufRead' }, {
  pattern = { '*.ets' },
  command = 'setfiletype typescript',
})

-- ui
vim.cmd 'syntax off'
vim.opt.colorcolumn = { 80, 120 }
vim.opt.cursorline = true
vim.opt.laststatus = 0
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank {
      higroup = 'Visual',
      timeout = 300,
    }
  end,
})
vim.fn.sign_define {
  {
    name = 'DiagnosticSignError',
    text = 'E',
    texthl = 'DiagnosticSignError',
    linehl = 'ErrorLine',
  },
  {
    name = 'DiagnosticSignWarn',
    text = 'W',
    texthl = 'DiagnosticSignWarn',
    linehl = 'WarningLine',
  },
  {
    name = 'DiagnosticSignInfo',
    text = 'I',
    texthl = 'DiagnosticSignInfo',
    linehl = 'InfoLine',
  },
  {
    name = 'DiagnosticSignHint',
    text = 'H',
    texthl = 'DiagnosticSignHint',
    linehl = 'HintLine',
  },
}

load_local_config '.nvim.lua'
load_plugins {
  -- edit
  --   'arthurxavierx/vim-caser',
  'romainl/vim-cool',
  --   'diartyz/vim-utils',
  --   'gcmt/wildfire.vim',
  --   'inkarkat/vim-visualrepeat',
  --   require 'plugins/autotag',
  require 'plugins/comment',
  --   require 'plugins/easy-align',
  --   require 'plugins/emmet',
  require 'plugins/hop',
  require 'plugins/leap',
  --   require 'plugins/sideways',
  --   require 'plugins/sort-json',
  require 'plugins/substitute',
  require 'plugins/switch',
  require 'plugins/targets',
  --   require 'plugins/template-string',
  require 'plugins/visual-multi',
  require 'plugins/wordmotion',
  { 'abecodes/tabout.nvim', config = true, dependencies = 'nvim-treesitter/nvim-treesitter', event = 'InsertEnter' },
  --   { 'bronson/vim-visual-star-search', event = 'VeryLazy' },
  --   { 'inkarkat/vim-AdvancedSorters', dependencies = 'inkarkat/vim-ingo-library' },
  { 'kana/vim-textobj-entire', dependencies = 'kana/vim-textobj-user', keys = { 'c', 'd', 'v', 'y' } },
  { 'michaeljsmith/vim-indent-object', keys = { 'c', 'd', 'v', 'y' } },
  { 'tpope/vim-surround', dependencies = 'tpope/vim-repeat', keys = { 'c', 'd', 'v', 'y' } },
  { 'tpope/vim-unimpaired', dependencies = 'tpope/vim-repeat', keys = { '[', ']' } },
  {
    'danymat/neogen',
    cmd = 'Neogen',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'L3MON4D3/LuaSnip' },
    opts = { snippet_engine = 'luasnip' },
  },

  -- lsp
  require 'plugins/cmp',
  require 'plugins/fidget',
  require 'plugins/lexima',
  require 'plugins/lsp',
  require 'plugins/null-ls',
  require 'plugins/signature',
  require 'plugins/treesitter',

  -- project
  --   'lambdalisue/suda.vim',
  require 'plugins/buffers',
  require 'plugins/ctrlsf',
  require 'plugins/fugtive',
  require 'plugins/harpoon',
  require 'plugins/session',
  --   require 'plugins/sniprun',
  require 'plugins/telescope',
  --   require 'plugins/todo',
  require 'plugins/toggleterm',
  require 'plugins/tree',
  --   require 'plugins/trouble',
  require 'plugins/undotree',
  --   { 'tpope/vim-sleuth', event = 'VeryLazy' },

  -- ui
  --   'chemzqm/wxapp.vim',
  require 'plugins/bufferline',
  require 'plugins/context',
  require 'plugins/dressing',
  require 'plugins/everforest',
  require 'plugins/gitgutter',
  require 'plugins/indent-blankline',
  --   require 'plugins/markdown',
  require 'plugins/noice',
  --   require 'plugins/syntax',
  --   { 'dhruvasagar/vim-prosession', dependencies = 'tpope/vim-obsession' },
  --   { 'dstein64/vim-startuptime', cmd = 'StartupTime' },
  { 'folke/which-key.nvim', cmd = 'WhichKey', config = true },
  --   { 'ntpeters/vim-better-whitespace', event = 'VeryLazy' },
}
