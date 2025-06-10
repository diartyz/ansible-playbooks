local loadPlugins = require 'core/lazy'
local loadLocalConfig = require('core/utils').loadLocalConfig

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
vim.opt.expandtab = true
vim.opt.ignorecase = true
vim.opt.shiftround = true
vim.opt.shiftwidth = 0
vim.opt.tabstop = 2

-- mappings
vim.api.nvim_create_user_command('E', 'edit $MYVIMRC', { nargs = 0 })
vim.api.nvim_create_user_command('R', 'update|source $MYVIMRC', { nargs = 0 })
vim.api.nvim_create_user_command('Q', 'qa!', { nargs = 0 })
vim.api.nvim_create_user_command('W', 'noautocmd w', { nargs = 0 })
-- vim.api.nvim_create_user_command(
--   'Code',
--   [[exe "silent !code '" . getcwd() . "' --goto '" . expand('%') . ":" . line('.') . ":" . col('.') . "'"]],
--   { nargs = 0 }
-- )
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.keymap.set('i', '<c-a>', '<c-o>I')
vim.keymap.set('i', '<c-e>', '<c-o>A')
vim.keymap.set('n', '<bs>', '<cmd>nohlsearch|match none<cr>')
vim.keymap.set('n', '<c-h>', '<cmd>nohlsearch|match none<cr>')
vim.keymap.set('n', '<leader>m', ':match IncSearch /\\<<c-r><c-w>\\>/<cr>')
vim.keymap.set('n', '<leader>q', '<cmd>q<cr>')
vim.keymap.set('n', '<leader>s', '<cmd>update<cr>')
vim.keymap.set('n', '<leader>x', '<cmd>bdelete<cr>')
vim.keymap.set('n', '<leader><leader>q', '<cmd>q!<cr>')
vim.keymap.set('n', '<leader><leader>s', '<cmd>noautocmd update<cr>')
vim.keymap.set('n', 'cf', [[<cmd>let @+=expand('%')<cr>]])
vim.keymap.set('n', 'cp', [[<cmd>let @+=expand('%:p')<cr>]])
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
vim.opt.jumpoptions = { 'stack' }
vim.opt.laststatus = 0
vim.opt.number = true
vim.opt.termguicolors = true
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank {
      higroup = 'Visual',
      timeout = 300,
    }
  end,
})

loadLocalConfig 'nvim.lua'
loadPlugins {
  -- edit
  require 'plugins/comment',
  require 'plugins/leap',
  -- require 'plugins/neogen',
  -- require 'plugins/osc52',
  -- require 'plugins/sort-json',
  require 'plugins/substitute',
  require 'plugins/switch',
  require 'plugins/targets',
  require 'plugins/text-case',
  require 'plugins/visual-multi',
  { 'abecodes/tabout.nvim', dependencies = 'nvim-treesitter/nvim-treesitter', event = 'InsertEnter', config = true },
  -- { 'axelvc/template-string.nvim', opts = { remove_template_string = true } },
  { 'chaoren/vim-wordmotion', event = 'VeryLazy', init = function() vim.g.wordmotion_prefix = '<leader>' end },
  -- { 'diartyz/vim-utils' },
  -- { 'gcmt/wildfire.vim' },
  { 'inkarkat/vim-AdvancedSorters', dependencies = 'inkarkat/vim-ingo-library' },
  -- { 'inkarkat/vim-visualrepeat' },
  -- { 'junegunn/vim-easy-align', keys = { { 'ga', '<plug>(EasyAlign)', mode = { 'n', 'x' } } } },
  { 'kana/vim-textobj-entire', dependencies = 'kana/vim-textobj-user', event = 'VeryLazy' },
  { 'michaeljsmith/vim-indent-object', event = 'VeryLazy' },
  { 'tpope/vim-sleuth' },
  { 'tpope/vim-surround', dependencies = 'tpope/vim-repeat', event = 'VeryLazy' },
  { 'tpope/vim-unimpaired', dependencies = 'tpope/vim-repeat', keys = { '[', ']', 'yo' } },
  -- { 'windwp/nvim-ts-autotag', dependencies = 'nvim-treesitter/nvim-treesitter', config = true },

  -- lsp
  require 'plugins/cmp',
  require 'plugins/codecompanion',
  require 'plugins/copilot',
  require 'plugins/lexima',
  require 'plugins/lsp',
  require 'plugins/null-ls',
  -- require 'plugins/tabnine',
  { 'j-hui/fidget.nvim', event = 'LspAttach', opts = { notification = { window = { winblend = 0 } } } },
  { 'ray-x/lsp_signature.nvim', event = 'LspAttach', config = true },

  -- project
  -- require 'plugins/close-buffers',
  require 'plugins/ctrlsf',
  require 'plugins/far',
  require 'plugins/fugitive',
  require 'plugins/fzf',
  require 'plugins/harpoon',
  -- require 'plugins/sniprun',
  require 'plugins/telescope',
  require 'plugins/todo',
  require 'plugins/toggleterm',
  require 'plugins/tree',
  -- require 'plugins/trouble',
  require 'plugins/undotree',
  { 'lambdalisue/suda.vim', cmd = { 'SudaRead', 'SudaWrite' } },
  { 'rmagatti/auto-session', opts = { session_lens = { load_on_setup = false } } },
  { 'wsdjeg/vim-fetch' },

  -- ui
  require 'plugins/bufferline',
  require 'plugins/dropbar',
  require 'plugins/everforest',
  require 'plugins/gitsigns',
  require 'plugins/indent-blankline',
  require 'plugins/markdown-preview',
  require 'plugins/noice',
  require 'plugins/treesitter',
  require 'plugins/treesitter-textobjects',
  require 'plugins/ufo',
  require 'plugins/vgit',
  -- { 'dstein64/vim-startuptime', cmd = 'StartupTime' },
  { 'folke/which-key.nvim', cmd = 'WhichKey', opts = { delay = 300 } },
  -- { 'kevinhwang91/nvim-bqf', ft = 'qf' },
  -- { 'ntpeters/vim-better-whitespace', event = 'VeryLazy' },
  -- { 'sheerun/vim-polyglot', config = function() vim.g.vim_markdown_no_default_key_mappings = 1 end },
  { 'stevearc/dressing.nvim', event = 'VeryLazy', config = true },
}
