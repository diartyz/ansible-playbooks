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
vim.api.nvim_create_user_command(
  'Code',
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
vim.keymap.set('n', '<leader>x', '<cmd>bdelete<cr>')
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

load_local_config 'nvim.lua'
load_plugins {
  -- edit
  'tpope/vim-sleuth',
  --   'diartyz/vim-utils',
  --   'gcmt/wildfire.vim',
  --   'inkarkat/vim-visualrepeat',
  require 'plugins/comment',
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
    keys = {
      {
        's',
        function() require('leap').leap { target_windows = require('leap.user').get_focusable_windows() } end,
        mode = { 'n', 'o', 'x' },
      },
    },
    config = function()
      require('leap').opts.max_phase_one_targets = 0
      vim.api.nvim_set_hl(0, 'LeapBackdrop', { link = 'Comment' })
    end,
  },
  {
    'johmsalas/text-case.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim' },
    cmd = 'TextCaseOpenTelescope',
    keys = { { '<leader>c', '<cmd>TextCaseOpenTelescope<cr>', mode = { 'n', 'x' } } },
    opts = { default_keymappings_enabled = false },
  },
  {
    'mg979/vim-visual-multi',
    keys = { { '<c-n>', mode = { 'n', 'x' } }, { '<c-e>', mode = 'x' } },
    init = function() vim.g.VM_maps = { ['Visual Cursors'] = '<c-e>' } end,
    config = function() vim.api.nvim_set_hl(0, 'VM_Mono', { link = 'DiffAdd' }) end,
  },

  -- lsp
  'gauteh/vim-cppman',
  require 'plugins/cmp',
  require 'plugins/lsp',
  require 'plugins/null-ls',
  require 'plugins/treesitter',
  -- {
  --   'codota/tabnine-nvim',
  --   build = './dl_binaries.sh',
  --   enabled = not vim.g.disable_ai,
  --   event = 'InsertEnter',
  --   config = function()
  --     require('tabnine').setup { accept_keymap = false }
  --     vim.keymap.set('i', '<c-l>', require('tabnine.keymaps').accept_suggestion, { expr = true })
  --   end,
  -- },
  {
    'cohama/lexima.vim',
    event = 'InsertEnter',
    config = function()
      vim.g.lexima_accept_pum_with_enter = 0
      vim.g.lexima_map_escape = ''
    end,
  },
  {
    'github/copilot.vim',
    enabled = not vim.g.disable_ai,
    event = 'InsertEnter',
    config = function()
      vim.g.copilot_no_tab_map = true
      vim.keymap.set('i', '<c-l>', 'copilot#Accept("<cr>")', { expr = true, replace_keycodes = false })
      vim.keymap.set('i', '<c-y>', '<Plug>(copilot-accept-word)')
    end,
  },
  {
    'j-hui/fidget.nvim',
    event = 'LspAttach',
    opts = { notification = { window = { winblend = 0 } } },
  },
  {
    'olimorris/codecompanion.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    enabled = not vim.g.disable_ai,
    cmd = 'AI',
    config = function()
      require('codecompanion').setup {
        strategies = {
          chat = { adapter = 'copilot' },
          inline = { adapter = 'copilot' },
        },
      }
      vim.api.nvim_create_user_command('AI', 'CodeCompanionChat Toggle', { nargs = 0 })
    end,
  },

  -- project
  'lambdalisue/suda.vim',
  'wsdjeg/vim-fetch',
  require 'plugins/ctrlsf',
  require 'plugins/fzf',
  require 'plugins/harpoon',
  require 'plugins/sniprun',
  require 'plugins/telescope',
  require 'plugins/todo',
  require 'plugins/toggleterm',
  require 'plugins/tree',
  { 'rmagatti/auto-session', opts = { session_lens = { load_on_setup = false } } },
  {
    'folke/trouble.nvim',
    dependencies = 'nvim-tree/nvim-web-devicons',
    cmd = 'Trouble',
    opts = { focus = true },
  },
  {
    'kazhala/close-buffers.nvim',
    cmd = { 'Bdforce', 'Bdall' },
    config = function()
      require('close_buffers').setup()
      vim.api.nvim_create_user_command(
        'Bdforce',
        function() require('close_buffers').wipe { type = 'this' } end,
        { nargs = 0 }
      )
      vim.api.nvim_create_user_command(
        'Bdall',
        function() require('close_buffers').wipe { type = 'all' } end,
        { nargs = 0 }
      )
    end,
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
  require 'plugins/noice',
  require 'plugins/vgit',
  { 'dstein64/vim-startuptime', cmd = 'StartupTime' },
  { 'folke/which-key.nvim', cmd = 'WhichKey', opts = { delay = 300 } },
  { 'kevinhwang91/nvim-bqf', ft = 'qf' },
  { 'ntpeters/vim-better-whitespace', event = 'VeryLazy' },
  { 'romainl/vim-cool', event = 'VeryLazy' },
  --   { 'sheerun/vim-polyglot', config = function() vim.g.vim_markdown_no_default_key_mappings = 1 end },
  { 'stevearc/dressing.nvim', event = 'VeryLazy', config = true },
  {
    'iamcco/markdown-preview.nvim',
    cmd = 'MarkdownPreview',
    ft = 'markdown',
    build = function() vim.fn['mkdp#util#install']() end,
  },
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
    config = function() vim.keymap.set({ 'n', 'x' }, 'gz', require('treesitter-context').go_to_context) end,
  },
}
