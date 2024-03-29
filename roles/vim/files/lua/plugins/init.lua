return {
  require 'plugins/treesitter',

  -- cmp
  require 'plugins/cmp',
  -- require 'plugins/copilot',
  require 'plugins/lexima',

  -- edit
  -- 'arthurxavierx/vim-caser',
  'bronson/vim-visual-star-search',
  -- 'diartyz/vim-utils',
  -- 'gcmt/wildfire.vim',
  -- 'inkarkat/vim-visualrepeat',
  'justinmk/vim-sneak',
  'michaeljsmith/vim-indent-object',
  -- require 'plugins/autotag',
  require 'plugins/comment',
  -- require 'plugins/easy-align',
  require 'plugins/emmet',
  require 'plugins/hop',
  require 'plugins/sideways',
  -- require 'plugins/sort-json',
  require 'plugins/substitute',
  -- require 'plugins/switch',
  require 'plugins/targets',
  -- require 'plugins/template-string',
  require 'plugins/visual-multi',
  require 'plugins/wordmotion',
  -- { 'inkarkat/vim-AdvancedSorters', dependencies = 'inkarkat/vim-ingo-library' },
  { 'kana/vim-textobj-entire', dependencies = 'kana/vim-textobj-user' },
  { 'tpope/vim-surround', dependencies = 'tpope/vim-repeat' },
  { 'tpope/vim-unimpaired', dependencies = 'tpope/vim-repeat' },

  -- lsp
  require 'plugins/fidget',
  require 'plugins/lsp',
  require 'plugins/null-ls',

  -- project
  'lambdalisue/suda.vim',
  'tpope/vim-sleuth',
  require 'plugins/buffers',
  require 'plugins/ctrlsf',
  require 'plugins/fugtive',
  require 'plugins/local',
  require 'plugins/session',
  -- require 'plugins/sniprun',
  require 'plugins/telescope',
  -- require 'plugins/todo',
  require 'plugins/toggleterm',
  require 'plugins/tree',
  -- require 'plugins/trouble',
  require 'plugins/undotree',

  -- ui
  -- 'chemzqm/wxapp.vim',
  'ntpeters/vim-better-whitespace',
  require 'plugins/bufferline',
  -- require 'plugins/context',
  require 'plugins/dressing',
  require 'plugins/everforest',
  require 'plugins/gitsigns',
  require 'plugins/indent-blankline',
  require 'plugins/markdown',
  require 'plugins/noice',
  -- require 'plugins/syntax',
  -- require 'plugins/vgit',
}
