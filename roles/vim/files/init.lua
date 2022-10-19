local function Plug(args)
  if type(args) == 'string' then
    vim.fn['plug#'](args)
    return
  end
  local opts = vim.empty_dict()
  for key, value in pairs(args) do
    if key ~= 1 and key ~= 'requires' then
      opts[key] = value
    end
  end
  vim.fn['plug#'](args[1], opts)
  if not args.requires then
    return
  end
  if type(args.requires) == 'string' or not vim.tbl_islist(args.requires) then
    Plug(args.requires)
    return
  end
  for i = 1, #args.requires do
    Plug(args.requires[i])
  end
end

local function install_nvim_sort_json(_)
  vim.cmd '!yarn install --frozen-lockfile'
  vim.cmd ':UpdateRemotePlugins'
end

vim.call 'plug#begin'

-- cmp
Plug 'cohama/lexima.vim'
-- Plug { 'neoclide/coc.nvim', branch = 'release', requires = 'SirVer/ultisnips' }
Plug {
  'hrsh7th/nvim-cmp',
  requires = {
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-nvim-lua',
    'hrsh7th/cmp-path',
    'onsails/lspkind.nvim',
    { 'quangnguyen30192/cmp-nvim-ultisnips', requires = 'SirVer/ultisnips' },
  }
}

-- edit
Plug 'AndrewRadev/sideways.vim'
Plug 'arthurxavierx/vim-caser'
Plug 'chaoren/vim-wordmotion'
Plug 'diartyz/vim-utils'
Plug 'inkarkat/vim-ReplaceWithRegister'
Plug 'inkarkat/vim-visualrepeat'
Plug 'junegunn/vim-easy-align'
Plug 'mattn/emmet-vim'
Plug 'mg979/vim-visual-multi'
Plug 'michaeljsmith/vim-indent-object'
Plug 'nelstrom/vim-visual-star-search'
Plug 'phaazon/hop.nvim'
Plug 'tommcdo/vim-exchange'
Plug 'wellle/targets.vim'
Plug { 'diartyz/nvim-sort-json', ['do'] = install_nvim_sort_json }
Plug { 'inkarkat/vim-AdvancedSorters', requires = 'inkarkat/vim-ingo-library' }
Plug { 'kana/vim-textobj-entire', requires = 'kana/vim-textobj-user' }
Plug { 'tpope/vim-surround', requires = 'tpope/vim-repeat' }
Plug { 'tpope/vim-unimpaired', requires = 'tpope/vim-repeat' }
Plug {
  'numToStr/Comment.nvim',
  requires = {
    'JoosepAlviste/nvim-ts-context-commentstring',
    requires = { 'nvim-treesitter/nvim-treesitter', ['do'] = ':TSUpdate' },
  },
}
Plug {
  'windwp/nvim-ts-autotag', ['do'] = ':TSUpdate',
  requires = { 'nvim-treesitter/nvim-treesitter', ['do'] = ':TSUpdate' }
}

-- lsp
Plug 'j-hui/fidget.nvim'
Plug 'jose-elias-alvarez/null-ls.nvim'
Plug 'jose-elias-alvarez/typescript.nvim'
Plug 'neovim/nvim-lspconfig'
Plug {
  'williamboman/mason.nvim',
  requires = { 'williamboman/mason-lspconfig.nvim', 'WhoIsSethDaniel/mason-tool-installer.nvim' }
}

-- project
Plug 'akinsho/toggleterm.nvim'
Plug 'dyng/ctrlsf.vim'
Plug 'lambdalisue/suda.vim'
Plug 'mbbill/undotree'
Plug 'rbgrouleff/bclose.vim'
Plug 'sgur/vim-editorconfig'
Plug 'tpope/vim-fugitive'
Plug 'vim-scripts/BufOnly.vim'
Plug { 'folke/todo-comments.nvim', requires = 'nvim-lua/plenary.nvim' }
Plug { 'nvim-telescope/telescope.nvim', requires = { 'nvim-lua/plenary.nvim', 'kyazdani42/nvim-web-devicons' } }
Plug { 'tpope/vim-obsession', requires = 'dhruvasagar/vim-prosession' }
Plug {
  'Shougo/defx.nvim',
  ['do'] = ':UpdateRemotePlugins',
  requires = {
    'kristijanhusak/defx-git',
    'kristijanhusak/defx-icons',
  },
}

-- ui
Plug 'chemzqm/wxapp.vim'
Plug 'lewis6991/gitsigns.nvim'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'rcarriga/nvim-notify'
Plug 'sainnhe/everforest'
Plug 'sheerun/vim-polyglot'
Plug 'stevearc/dressing.nvim'
Plug { 'itchyny/lightline.vim', requires = 'mengelbrecht/lightline-bufferline' }
Plug { 'tanvirtin/vgit.nvim', requires = 'nvim-lua/plenary.nvim' }

vim.call 'plug#end'

-- general
vim.opt.clipboard = { 'unnamed', 'unnamedplus' }
vim.opt.fileencodings = { 'utf-8', 'gb2312' }
vim.opt.foldlevel = 99
vim.opt.foldmethod = 'indent'
vim.opt.pastetoggle = '<F12>'
vim.opt.swapfile = false
vim.opt.undodir = '/tmp/vim'
vim.opt.undofile = true
vim.opt.updatetime = 300
vim.opt.wildignore = { '*/dist/*', '*/node_modules/*' }
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank {
      higroup = 'Visual',
      timeout = 300,
    }
  end,
})

-- mapping
vim.api.nvim_create_user_command('E', 'edit $MYVIMRC', { nargs = 0 })
vim.api.nvim_create_user_command('Jq', [[%!jq '--sort-keys']], { nargs = 0 })
vim.api.nvim_create_user_command('OpenInVSCode',
  [[exe "silent !code '" . getcwd() . "' --goto '" . expand('%') . ":" . line('.') . ":" . col('.') . "'"]],
  { nargs = 0 }
)
vim.api.nvim_create_user_command('R', 'w|source $MYVIMRC', { nargs = 0 })
vim.api.nvim_create_user_command('W', 'noautocmd w', { nargs = 0 })
vim.g.mapleader = ' '
vim.keymap.set('i', '<c-o>', '<esc>O')
vim.keymap.set('n', '<bs>', '<cmd>nohlsearch<cr>')
vim.keymap.set('n', '<c-h>', '<cmd>nohlsearch<cr>')
vim.keymap.set('n', '<leader><leader>q', '<cmd>qall!<cr>')
vim.keymap.set('n', '<leader><leader>s', '<cmd>wall<cr>')
vim.keymap.set('n', '<leader>q', '<cmd>q<cr>')
vim.keymap.set('n', '<leader>s', '<cmd>w<cr>')
vim.keymap.set('n', 'cp', [[<cmd>let @+=expand('%') . ' ' . line('.') . ':' . col('.')<cr>]])

-- search & tab
vim.opt.expandtab = true
vim.opt.ignorecase = true
vim.opt.shiftround = true
vim.opt.shiftwidth = 0
vim.opt.smartcase = true
vim.opt.tabstop = 2

-- ui
vim.opt.colorcolumn = { 80, 120 }
vim.opt.cursorline = true
vim.opt.laststatus = 3
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.showtabline = 2
vim.opt.termguicolors = true

-- autotag
require 'nvim-ts-autotag'.setup()

-- bufOnly
vim.keymap.set('n', '<leader>d', '<cmd>BufOnly<cr>')

-- bclose
vim.g.bclose_no_plugin_maps = true
vim.keymap.set('n', '<leader>x', '<cmd>Bclose<cr>')

-- cmp
local cmp = require 'cmp'
cmp.setup {
  formatting = {
    format = function(entry, vim_item)
      return require 'lspkind'.cmp_format { mode = 'symbol_text' } (entry, vim_item)
    end
  },
  mapping = cmp.mapping.preset.insert {
    ['<c-space>'] = cmp.mapping.complete(),
    ['<tab>'] = cmp.mapping.confirm { select = false },
  },
  snippet = {
    expand = function(args)
      vim.fn['UltiSnips#Anon'](args.body)
    end,
  },
  sources = cmp.config.sources({
    { name = 'nvim_lua' },
  }, {
    { name = 'nvim_lsp' },
    { name = 'ultisnips' },
  }, {
    { name = 'buffer' },
  }),
}
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' },
  }
})
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' },
  }, {
    { name = 'cmdline' },
  })
})

-- -- coc
-- vim.g.coc_global_extensions = {
--   'coc-tabnine',
--   'coc-snippets',
--   'coc-tsserver',
--   'coc-eslint',
--   'coc-prettier',
--   'coc-graphql',
--   'coc-sumneko-lua',
--   'coc-vimlsp',
-- }
-- vim.g.UltiSnipsExpandTrigger = '<c-;>'
-- vim.keymap.set('i', '<c-space>', vim.fn['coc#refresh'], { expr = true })
-- vim.keymap.set('i', '<tab>', function()
--   if vim.call 'coc#pum#visible' then
--     vim.call 'coc#pum#confirm'
--   else
--     vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<tab>', true, false, true), 'in', true)
--   end
-- end)
-- vim.keymap.set('n', '<c-j>', '<Plug>(coc-diagnostic-next)')
-- vim.keymap.set('n', '<c-k>', '<Plug>(coc-diagnostic-prev)')
-- vim.keymap.set('n', '<leader>.', '<Plug>(coc-codeaction-cursor)')
-- vim.keymap.set('n', '<leader>gd', '<Plug>(coc-references)')
-- vim.keymap.set('n', '<leader>r', '<Plug>(coc-rename)')
-- vim.keymap.set('n', 'gd', '<Plug>(coc-definition)')
-- vim.keymap.set('n', 'gh', function() vim.fn.CocActionAsync 'doHover' end)
-- vim.keymap.set('n', 'gi', '<Plug>(coc-implementation)')
-- vim.keymap.set('n', 'go', function() vim.fn.CocActionAsync('runCommand', 'editor.action.organizeImport') end)
-- vim.keymap.set('n', 'gp', '<Plug>(coc-format)')
-- vim.keymap.set({ 'o', 'x' }, 'af', '<Plug>(coc-funcobj-a)')
-- vim.keymap.set({ 'o', 'x' }, 'if', '<Plug>(coc-funcobj-i)')

-- comment
require 'Comment'.setup {
  pre_hook = require 'ts_context_commentstring.integrations.comment_nvim'.create_pre_hook()
}

-- ctrlsf
vim.g.ctrlsf_auto_focus = {
  at = 'start',
}
vim.g.ctrlsf_extra_backend_args = {
  ag = '--hidden --ignore-dir .git/ --nocolor',
  rg = '--hidden -g "!.git/" --color=never',
}
vim.g.ctrlsf_populate_qflist = 1
vim.keymap.set('n', '<c-s>', '<cmd>CtrlSFToggle<cr>')
vim.keymap.set('n', '<leader>f', '<plug>CtrlSFPrompt')
vim.keymap.set('x', '<leader>f', '<plug>CtrlSFVwordPath')

-- defx
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
    vim.keymap.set('n', 'U', [[<cmd>Defx -search_recursive=`expand('%:p')`<cr>]], { buffer = true })
    vim.keymap.set('n', 'q', function()
      vim.fn['defx#call_async_action'] 'quit'
    end, { buffer = true })
    vim.keymap.set('n', '<c-e>', function()
      vim.fn['defx#call_async_action'] 'quit'
    end, { buffer = true })
    vim.keymap.set('n', '<cr>', function()
      vim.fn['defx#call_async_action']('multi', { 'drop', 'quit' })
    end, { buffer = true })
    vim.keymap.set('n', 'h', function()
      vim.fn['defx#call_async_action'] 'close_tree'
    end, { buffer = true })
    vim.keymap.set('n', 'l', function()
      if vim.call 'defx#is_directory' then
        vim.fn['defx#call_async_action'] 'open_tree'
      else
        vim.fn['defx#call_async_action'] 'preview'
      end
    end, { buffer = true })
    vim.keymap.set('n', 'o', function()
      vim.fn['defx#call_async_action'] 'drop'
    end, { buffer = true })
    vim.keymap.set('n', 'p', function()
      vim.fn['defx#call_async_action'] 'paste'
    end, { buffer = true })
    vim.keymap.set('n', 'cc', function()
      vim.fn['defx#call_async_action'] 'rename'
    end, { buffer = true })
    vim.keymap.set('n', 'cp', function()
      vim.fn['defx#call_async_action'] 'yank_path'
    end, { buffer = true })
    vim.keymap.set('n', 'dd', function()
      vim.fn['defx#call_async_action'] 'move'
    end, { buffer = true })
    vim.keymap.set('n', 'yy', function()
      vim.fn['defx#call_async_action'] 'copy'
    end, { buffer = true })
    vim.keymap.set('n', 'D', function()
      vim.fn['defx#call_async_action']('remove_trash', { 'force' })
    end, { buffer = true })
    vim.keymap.set('n', 'M', function()
      vim.fn['defx#call_async_action'] 'new_multiple_files'
    end, { buffer = true })
    vim.keymap.set('n', 'R', function()
      vim.fn['defx#call_async_action'] 'redraw'
    end, { buffer = true })
    vim.keymap.set('n', 'v', function()
      vim.fn['defx#call_async_action'] 'toggle_select'
      vim.api.nvim_feedkeys('j', 'in', true)
    end, { buffer = true })
    vim.keymap.set('n', 'C', function()
      vim.fn['defx#call_async_action'] 'clear_select_all'
    end, { buffer = true })
    vim.keymap.set('n', 'V', function()
      vim.fn['defx#call_async_action'] 'toggle_select_all'
    end, { buffer = true })
  end,
})

-- dressing
require 'dressing'.setup()

-- easy-align
vim.keymap.set({ 'n', 'x' }, 'ga', '<plug>(EasyAlign)')

-- emmet
vim.g.user_emmet_leader_key = '<c-q>'
vim.g.user_emmet_next_key = '<c-j>'
vim.g.user_emmet_prev_key = '<c-k>'
vim.keymap.set('i', '<c-y>', '<plug>(emmet-expand-word)')

-- everforest
vim.g.everforest_background = 'hard'
vim.g.everforest_better_performance = 1
vim.g.everforest_diagnostic_line_highlight = 1
vim.g.everforest_sign_column_background = 'none'
vim.g.everforest_transparent_background = 1
vim.api.nvim_command 'colorscheme everforest'
vim.api.nvim_command 'highlight Visual cterm=NONE ctermbg=241 gui=NONE guibg=#665c54'

-- fugitive
vim.keymap.set('n', '<leader>gb', '<cmd>Git blame<cr>')

-- gitsigns
require 'gitsigns'.setup {
  current_line_blame = true,
  signs = {
    add = { hl = 'GitSignsAdd', text = '+', numhl = 'GitSignsAddNr', linehl = 'GitSignsAddLn' },
    change = { hl = 'GitSignsChange', text = '~', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
    changedelete = { hl = 'GitSignsChange', text = '-', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
  },
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns
    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    map('n', ']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end)
    map('n', '[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end)
    map('n', '<leader>hR', gs.reset_buffer)
    map('n', '<leader>hS', gs.stage_buffer)
    map('n', '<leader>hd', gs.diffthis)
    map({ 'n', 'v' }, '<leader>hr', '<cmd>Gitsigns reset_hunk<cr>')
    map({ 'n', 'v' }, '<leader>hs', '<cmd>Gitsigns stage_hunk<cr>')
    map({ 'o', 'x' }, 'ih', '<cmd><c-u>Gitsigns select_hunk<cr>')
  end
}

-- hop
require 'hop'.setup()
vim.keymap.set('n', '<leader>/', '<cmd>HopPattern<cr>')
vim.keymap.set('n', '<leader>t', '<cmd>HopChar2<cr>')

-- indent-blankline
require 'indent_blankline'.setup()
vim.opt.list = true
vim.opt.listchars:append 'space:⋅'
vim.keymap.set('n', '<c-g>', '<c-g><cmd>IndentBlanklineRefresh<cr>')

-- lexima
vim.g.lexima_accept_pum_with_enter = 0
vim.g.lexima_map_escape = ''

-- lightline
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

-- lsp
require 'fidget'.setup {
  timer = {
    fidget_decay = 300,
    task_decay = 300,
  },
  window = {
    blend = 0,
  },
}
require 'mason'.setup()
require 'mason-lspconfig'.setup {
  automatic_installation = true,
  ensure_installed = {
    'graphql',
    'pylsp',
    'sumneko_lua',
    'tsserver',
    'vimls',
  },
}
local lsp_augroup = vim.api.nvim_create_augroup('LspFormatting', { clear = true })
local lsp_config = {
  capabilities = require 'cmp_nvim_lsp'.default_capabilities(),
  on_attach = function(_, bufnr)
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = lsp_augroup,
      buffer = bufnr,
      callback = function() vim.lsp.buf.format() end,
    })
  end,
}
require 'mason-lspconfig'.setup_handlers {
  function(server_name)
    require 'lspconfig'[server_name].setup(lsp_config)
  end,
  tsserver = function()
    require 'typescript'.setup {
      server = vim.tbl_extend('force', lsp_config, {
        init_options = {
          preferences = {
            importModuleSpecifierPreference = 'relative',
          },
        },
        on_attach = function(client, bufnr)
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
          vim.api.nvim_create_autocmd('BufWritePre', {
            group = lsp_augroup,
            buffer = bufnr,
            callback = function() vim.lsp.buf.format() end,
          })
        end,
      })
    }
  end,
  sumneko_lua = function()
    require 'lspconfig'.sumneko_lua.setup(vim.tbl_extend('force', lsp_config, {
      settings = {
        Lua = {
          diagnostics = {
            globals = { 'vim' },
          },
        },
      },
    }))
  end,
}
require 'mason-tool-installer'.setup {
  auto_update = true,
  ensure_installed = {
    'eslint_d',
    'prettierd',
  }
}
require 'null-ls'.setup {
  sources = {
    require 'null-ls'.builtins.code_actions.eslint_d,
    require 'null-ls'.builtins.diagnostics.eslint_d,
    require 'null-ls'.builtins.formatting.prettierd,
  },
}
vim.keymap.set('n', '<c-j>', vim.diagnostic.goto_next)
vim.keymap.set('n', '<c-k>', vim.diagnostic.goto_prev)
vim.keymap.set('n', '<c-t>', '<cmd>Telescope lsp_document_symbols<cr>')
vim.keymap.set('n', '<leader>.', vim.lsp.buf.code_action)
vim.keymap.set('n', '<leader>gd', '<cmd>Telescope lsp_references<cr>')
vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename)
vim.keymap.set('n', 'gd', '<cmd>Telescope lsp_definitions<cr>')
vim.keymap.set('n', 'gh', vim.lsp.buf.hover)
vim.keymap.set('n', 'gi', '<cmd>Telescope lsp_implementations<cr>')
vim.keymap.set('n', 'go', function()
  require 'typescript'.actions.removeUnused({ sync = true })
  require 'typescript'.actions.organizeImports({ sync = true })
end)
vim.keymap.set('n', 'gp', vim.lsp.buf.format)

-- nvim-sort-json
vim.g.sort_json = {
  orderOverride = {
    'name',
    'private',
    'version',
    'main',
    'module',
    'type',
    'types',
    'typings',
    'files',
    'publishConfig',
    'repository',
    'scripts'
  },
  orderUnderride = {
    'resolutions',
    'dependencies',
    'devDependencies',
    'peerDependencies',
    'source.organizeImports'
  },
}

-- sideways
vim.keymap.set('n', '[a', '<cmd>SidewaysLeft<cr>')
vim.keymap.set('n', ']a', '<cmd>SidewaysRight<cr>')
vim.keymap.set('n', 'gA', '<cmd>SidewaysJumpLeft<cr>')
vim.keymap.set('n', 'ga', '<cmd>SidewaysJumpRight<cr>')

-- targets
vim.g.targets_seekRanges = 'cc cr cb cB lc ac Ac lr lb ar ab lB Ar aB Ab AB'
vim.api.nvim_create_autocmd('User', {
  group = vim.api.nvim_create_augroup('targets', { clear = true }),
  pattern = 'targets#mappings#user',
  callback = function()
    vim.fn['targets#mappings#extend'] {
      a = {
        argument = {
          {
            o = '[<{([]',
            c = '[])}>]',
            s = ','
          },
        },
      },
      b = {
        pair = {
          {
            o = '(',
            c = ')',
          },
        },
      },
    }
  end,
})

-- telescope
require 'telescope'.setup {
  defaults = require 'telescope.themes'.get_dropdown {
    file_ignore_patterns = { '^.git/.*' },
    mappings = {
      i = {
        ['<esc>'] = 'close',
        ['<c-j>'] = 'cycle_history_next',
        ['<c-k>'] = 'cycle_history_prev',
      },
    },
  },
  pickers = {
    buffers = {
      previewer = false,
      mappings = {
        i = {
          ['<c-d>'] = 'delete_buffer',
        },
      },
    },
    find_files = {
      hidden = true,
    }
  },
}
vim.keymap.set('n', '<c-p>', '<cmd>Telescope find_files<cr>')
vim.keymap.set('n', '<leader>a', '<cmd>Telescope buffers<cr>')
vim.keymap.set('n', '<leader>m', '<cmd>Telescope marks<cr>')

-- terminal
require 'toggleterm'.setup {
  direction = 'float',
  float_opts = {
    border = 'none',
    width = function() return vim.o.columns end,
    height = function() return vim.o.lines end,
  },
}
local Terminal = require 'toggleterm.terminal'.Terminal
local lazygit = Terminal:new {
  cmd = 'lazygit',
}
local ranger = Terminal:new {
  cmd = 'ranger',
}
vim.keymap.set('n', '-', function() ranger:toggle() end)
vim.keymap.set('n', '<c-l>', function() lazygit:toggle() end)

-- todo-comments
require 'todo-comments'.setup {
  highlight = {
    keyword = 'bg',
    pattern = '<(KEYWORDS)>',
  },
  search = {
    pattern = '\b(KEYWORDS)\b',
  },
}
vim.keymap.set('n', '<leader>p', '<cmd>TodoTelescope<cr>')

-- treesitter
require 'nvim-treesitter.configs'.setup {
  ensure_installed = {
    'javascript',
    'typescript',
    'tsx',
  },
  autotag = {
    enable = true,
  },
  context_commentstring = {
    enable = true,
  },
}

-- undotree
vim.g.undotree_SetFocusWhenToggle = 1
vim.keymap.set('n', '<leader>u', '<cmd>UndotreeToggle<cr>')

-- vgit
require 'vgit'.setup {
  keymaps = {
    ['n ]h'] = 'hunk_down',
    ['n [h'] = 'hunk_up',
    ['n <leader>gh'] = 'buffer_history_preview',
    ['n <leader>gp'] = 'project_diff_preview',
  },
  settings = {
    live_blame = {
      enabled = false,
    },
    live_gutter = {
      enabled = false,
    },
    authorship_code_lens = {
      enabled = false,
    },
    signs = {
      definitions = {
        GitSignsAdd = {
          text = '+',
        },
        GitSignsDelete = {
          text = '-',
        },
        GitSignsChange = {
          text = '~',
        },
      },
    },
  }
}

-- vim-visual-multi
vim.g.VM_maps = {
  ['Visual Cursors'] = '<c-l>',
}

-- wordmotion
vim.g.wordmotion_prefix = '<leader>'
