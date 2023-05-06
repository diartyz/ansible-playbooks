return {
  require 'plugins/treesitter',

  -- cmp
  require 'plugins/cmp',
  require 'plugins/copilot',
  require 'plugins/lexima',

  -- edit
  -- 'bronson/vim-visual-star-search',
  'gcmt/wildfire.vim',
  -- 'inkarkat/vim-visualrepeat',
  'michaeljsmith/vim-indent-object',
  require 'plugins/autotag',
  require 'plugins/comment',
  -- require 'plugins/easy-align',
  require 'plugins/emmet',
  require 'plugins/hop',
  require 'plugins/sideways',
  require 'plugins/sort-json',
  require 'plugins/substitute',
  require 'plugins/switch',
  require 'plugins/tabout',
  require 'plugins/targets',
  require 'plugins/template-string',
  require 'plugins/utils',
  require 'plugins/visual-multi',
  require 'plugins/wordmotion',
  -- { 'inkarkat/vim-AdvancedSorters', requires = 'inkarkat/vim-ingo-library' },
  { 'kana/vim-textobj-entire', requires = 'kana/vim-textobj-user' },
  { 'tpope/vim-surround', requires = 'tpope/vim-repeat' },
  { 'tpope/vim-unimpaired', requires = 'tpope/vim-repeat' },

  -- lsp
  require 'plugins/fidget',
  require 'plugins/lsp',
  require 'plugins/null-ls',

  -- project
  -- 'lambdalisue/suda.vim',
  require 'plugins/auto-session',
  require 'plugins/buffers',
  -- require 'plugins/bufonly',
  require 'plugins/ctrlsf',
  -- require 'plugins/defx',
  require 'plugins/fugtive',
  -- require 'plugins/im-select',
  require 'plugins/sniprun',
  require 'plugins/telescope',
  require 'plugins/todo',
  require 'plugins/toggleterm',
  require 'plugins/tree',
  require 'plugins/undotree',

  -- ui
  -- 'chemzqm/wxapp.vim',
  'sheerun/vim-polyglot',
  require 'plugins/context',
  require 'plugins/dressing',
  require 'plugins/everforest',
  require 'plugins/gitsigns',
  require 'plugins/indent-blankline',
  require 'plugins/lightline',
  require 'plugins/markdown',
  require 'plugins/noice',
  -- require 'plugins/vgit',
}