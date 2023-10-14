local load_plugins = require 'core/lazy'
local load_local_config = require 'core/local'

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
vim.api.nvim_create_user_command('W', 'noautocmd update', { nargs = 0 })
vim.api.nvim_create_user_command('X', 'noautocmd update|q', { nargs = 0 })
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
vim.keymap.set('n', '<leader><leader>s', '<cmd>noautocmd update|q<cr>')
vim.keymap.set('n', '<leader>q', '<cmd>q<cr>')
vim.keymap.set('n', '<leader>s', '<cmd>update<cr>')
vim.keymap.set('n', 'cf', [[<cmd>let @+=expand('%')<cr>]])
vim.keymap.set('n', 'cp', [[<cmd>let @+=expand('%:p')<cr>]])

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

load_local_config 'nvim.lua'
load_plugins {
  -- edit
  'tpope/vim-sleuth',
  --   'diartyz/vim-utils',
  --   'gcmt/wildfire.vim',
  --   'inkarkat/vim-visualrepeat',
  require 'plugins/comment',
  --   require 'plugins/emmet',
  --   require 'plugins/osc52',
  --   require 'plugins/sort-json',
  require 'plugins/substitute',
  require 'plugins/switch',
  require 'plugins/targets',
  { 'abecodes/tabout.nvim', dependencies = 'nvim-treesitter/nvim-treesitter', event = 'InsertEnter', config = true },
  --   { 'axelvc/template-string.nvim', opts = { remove_template_string = true } },
  --   { 'inkarkat/vim-AdvancedSorters', dependencies = 'inkarkat/vim-ingo-library' },
  { 'junegunn/vim-easy-align', keys = { { 'ga', '<plug>(EasyAlign)', mode = { 'n', 'x' } } } },
  { 'kana/vim-textobj-entire', dependencies = 'kana/vim-textobj-user', event = 'VeryLazy' },
  { 'michaeljsmith/vim-indent-object', event = 'VeryLazy' },
  { 'tpope/vim-surround', dependencies = 'tpope/vim-repeat', event = 'VeryLazy' },
  { 'tpope/vim-unimpaired', dependencies = 'tpope/vim-repeat', keys = { '[', ']', 'yo' } },
  --   { 'windwp/nvim-ts-autotag', dependencies = 'nvim-treesitter/nvim-treesitter', config = true },
  {
    'chaoren/vim-wordmotion',
    event = 'VeryLazy',
    init = function() vim.g.wordmotion_prefix = '<leader>' end,
  },
  --   {
  --     'danymat/neogen',
  --     dependencies = { 'nvim-treesitter/nvim-treesitter', 'L3MON4D3/LuaSnip' },
  --     cmd = 'Neogen',
  --     opts = { snippet_engine = 'luasnip' },
  --   },
  {
    'ggandor/leap.nvim',
    keys = { { 'S', '<Plug>(leap)', mode = { 'n', 'o', 'x' } } },
    config = function()
      vim.api.nvim_set_hl(0, 'LeapBackdrop', { link = 'Comment' })
      require('leap').opts.max_phase_one_targets = 0
    end,
  },
  --   {
  --     'arthurxavierx/vim-caser',
  --     init = function() vim.g.caser_prefix = '<leader>c' end,
  --   },
  --   {
  --     'johmsalas/text-case.nvim',
  --     dependencies = { 'nvim-telescope/telescope.nvim' },
  --     cmd = { 'TextCaseOpenTelescope', 'TextCaseOpenTelescopeLSPChange' },
  --     opts = { default_keymappings_enabled = false },
  --   },
  {
    'mg979/vim-visual-multi',
    keys = { { '<c-n>', mode = { 'n', 'x' } }, { '<c-e>', mode = 'x' } },
    init = function() vim.g.VM_maps = { ['Visual Cursors'] = '<c-e>' } end,
  },
  {
    'phaazon/hop.nvim',
    keys = {
      { '<leader>t', '<cmd>HopChar2<cr>', mode = { 'n', 'o', 'x' } },
    },
    config = true,
  },

  -- lsp
  require 'plugins/cmp',
  require 'plugins/fidget',
  require 'plugins/lsp',
  require 'plugins/null-ls',
  require 'plugins/treesitter',
  {
    'cohama/lexima.vim',
    event = 'InsertEnter',
    config = function()
      vim.g.lexima_accept_pum_with_enter = 0
      vim.g.lexima_map_escape = ''
    end,
  },

  -- project
  'lambdalisue/suda.vim',
  require 'plugins/ctrlsf',
  require 'plugins/fzf',
  require 'plugins/harpoon',
  --   require 'plugins/sniprun',
  require 'plugins/telescope',
  --   require 'plugins/todo',
  require 'plugins/toggleterm',
  require 'plugins/tree',
  'wsdjeg/vim-fetch',
  { 'rmagatti/auto-session', opts = { session_lens = { load_on_setup = false } } },
  {
    'folke/trouble.nvim',
    dependencies = 'nvim-tree/nvim-web-devicons',
    cmd = 'Trouble',
    opts = { focus = true },
  },
  {
    'kazhala/close-buffers.nvim',
    keys = {
      { '<leader>x', function() require('close_buffers').delete { type = 'this' } end },
      { '<leader>d', function() require('close_buffers').delete { type = 'other' } end },
    },
    config = true,
  },
  {
    'tpope/vim-fugitive',
    cmd = 'G',
    keys = { { '<leader>gb', '<cmd>G blame<cr>' }, { '<leader>gh', ':Gclog<cr>', mode = 'x' } },
  },
  {
    'mbbill/undotree',
    keys = { { '<leader>u', '<cmd>UndotreeToggle<cr>' } },
    config = function() vim.g.undotree_SetFocusWhenToggle = 1 end,
  },

  -- ui
  require 'plugins/bufferline',
  require 'plugins/everforest',
  require 'plugins/gitsigns',
  require 'plugins/markdown',
  require 'plugins/noice',
  require 'plugins/vgit',
  --   { 'dstein64/vim-startuptime', cmd = 'StartupTime' },
  { 'folke/which-key.nvim', cmd = 'WhichKey', opts = { delay = 300 } },
  --   { 'kevinhwang91/nvim-bqf', ft = 'qf' },
  --   { 'ntpeters/vim-better-whitespace', event = 'VeryLazy' },
  { 'romainl/vim-cool', event = 'VeryLazy' },
  { 'stevearc/dressing.nvim', event = 'VeryLazy', config = true },
  {
    'lukas-reineke/indent-blankline.nvim',
    event = 'VeryLazy',
    main = 'ibl',
    opts = { scope = { show_start = false, show_end = false } },
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    dependencies = 'nvim-treesitter/nvim-treesitter',
    event = 'VeryLazy',
    config = true,
  },
}
