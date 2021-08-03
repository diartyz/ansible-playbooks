call plug#begin('~/.vim/plugged')

Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' } | Plug 'kristijanhusak/defx-git' | Plug 'kristijanhusak/defx-icons'
Plug 'arthurxavierx/vim-caser'
Plug 'chaoren/vim-wordmotion'
Plug 'chemzqm/wxapp.vim'
Plug 'cohama/lexima.vim'
Plug 'diartyz/vim-utils'
Plug 'dyng/ctrlsf.vim'
Plug 'glepnir/lspsaga.nvim'
Plug 'hrsh7th/nvim-compe' | Plug 'tzachar/compe-tabnine', { 'do': './install.sh' }
Plug 'itchyny/lightline.vim' | Plug 'mengelbrecht/lightline-bufferline'
Plug 'jose-elias-alvarez/nvim-lsp-ts-utils' | Plug 'jose-elias-alvarez/null-ls.nvim'
Plug 'junegunn/vim-easy-align'
Plug 'kabouzeid/nvim-lspinstall'
Plug 'kana/vim-textobj-entire' | Plug 'kana/vim-textobj-user'
Plug 'lambdalisue/suda.vim'
Plug 'lewis6991/gitsigns.nvim' | Plug 'nvim-lua/plenary.nvim'
Plug 'machakann/vim-highlightedyank'
Plug 'mattn/emmet-vim'
Plug 'mbbill/undotree'
Plug 'mg979/vim-visual-multi'
Plug 'mhartington/formatter.nvim'
Plug 'michaeljsmith/vim-indent-object'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'nelstrom/vim-visual-star-search'
Plug 'neovim/nvim-lspconfig'
Plug 'ntpeters/vim-better-whitespace'
Plug 'nvim-lua/lsp-status.nvim'
Plug 'nvim-telescope/telescope.nvim' | Plug 'nvim-lua/popup.nvim' | Plug 'nvim-lua/plenary.nvim' | Plug 'kyazdani42/nvim-web-devicons'
Plug 'osyo-manga/vim-over'
Plug 'phaazon/hop.nvim'
Plug 'sainnhe/everforest'
Plug 'sgur/vim-editorconfig'
Plug 'sheerun/vim-polyglot'
Plug 'terryma/vim-expand-region'
Plug 'tommcdo/vim-exchange'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-obsession' | Plug 'dhruvasagar/vim-prosession'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'vim-scripts/BufOnly.vim'
Plug 'vim-scripts/ReplaceWithRegister'
Plug 'wellle/targets.vim'

call plug#end()

" general
set clipboard=unnamed,unnamedplus
set fileencodings=utf-8,gb2312
set foldlevel=99
set foldmethod=indent
set hidden
set mouse=a
set noswapfile
set pastetoggle=<F12>
set undodir=/tmp
set undofile
set updatetime=300
set wildignore=*/dist/*,*/node_modules/*

" mapping
command! -nargs=0 E :edit $MYVIMRC
command! -nargs=0 R :source $MYVIMRC
command! -nargs=0 SortJson :%!jq '--sort-keys' .
command! -nargs=0 W :noautocmd w
command! OpenInVSCode exe "silent !code '" . getcwd() . "' --goto '" . expand("%") . ":" . line(".") . ":" . col(".") . "'" | redraw!
inoremap <c-o> <esc>O
let mapleader = ' '
nnoremap <leader><leader>q :q!<cr>
nnoremap <leader><leader>s :w suda://%<cr>
nnoremap <leader>q :q<cr>
nnoremap <leader>s :w<cr>
nnoremap cf :let @+=expand("%")<cr>
nnoremap ch :nohlsearch<cr>
tnoremap <esc> <c-\><C-n>

" search
set hlsearch
set ignorecase
set incsearch
set smartcase

" tab
set expandtab
set shiftround
set shiftwidth=0
set tabstop=2

" theme
function! s:everforest_custom() abort
  highlight! link BufferInactiveIndex BufferInactive
endfunction
augroup EverforestCustom
  autocmd!
  autocmd ColorScheme everforest call s:everforest_custom()
augroup END
let g:everforest_background = 'hard'
let g:everforest_better_performance = 1
let g:everforest_diagnostic_line_highlight = 1
let g:everforest_sign_column_background = 'none'
let g:everforest_transparent_background = 1
let g:indent_guides_auto_colors = 0
colorscheme everforest
set colorcolumn=80,120
set cul
set laststatus=2
set number
set relativenumber
set showtabline=2
if has('nvim')
  set termguicolors
endif

" ctrlsf
let g:ctrlsf_auto_focus = {
      \ "at" : "start",
      \ }
let g:ctrlsf_extra_backend_args = {
      \ 'ag': '--hidden --ignore-dir .git/ --nocolor',
      \ 'rg': '--hidden -g "!.git/" --color=never',
      \ }
let g:ctrlsf_populate_qflist = 1
nmap <leader>f <Plug>CtrlSFPrompt
nnoremap <c-s> :CtrlSFToggle<cr>
xmap <leader>f <Plug>CtrlSFVwordPath

" completion
inoremap <expr><c-space> compe#complete()
inoremap <expr><tab> pumvisible() ? compe#confirm(lexima#expand('<LT>CR>', 'i')) : "\<c-g>u\<tab>"
set completeopt=menuone,noinsert,noselect
lua << EOF
  require'compe'.setup {
    resolve_timeout = 0,
    source = {
      nvim_lsp = true,
      path = true,
      tabnine = true,
    },
  }
EOF

" defx
autocmd FileType defx call s:defx_my_settings()
call defx#custom#option('_', {
      \ 'columns': 'git:indent:icons:mark:filename:type',
      \ 'resume': 1,
      \ 'show_ignored_files': 1,
      \ 'split': 'vertical',
      \ 'winwidth': '39',
      \ })
function! s:defx_my_settings() abort
  nnoremap <buffer><expr> <c-e>
        \ defx#async_action('quit')
  nnoremap <buffer><expr> <cr>
        \ defx#async_action('multi', ['drop', 'quit'])
  nnoremap <buffer><expr> h
        \ defx#async_action('close_tree')
  nnoremap <buffer><expr> l
        \ defx#is_directory() ?
        \ defx#async_action('open_tree') :
        \ defx#async_action('drop')
  nnoremap <buffer><expr> r
        \ defx#async_action('rename')
  nnoremap <buffer><expr> m
        \ defx#async_action('move')
  nnoremap <buffer><expr> cp
        \ defx#async_action('copy')
  nnoremap <buffer><expr> p
        \ defx#async_action('paste')
  nnoremap <buffer><expr> D
        \ defx#async_action('remove', ['force'])
  nnoremap <buffer><expr> M
        \ defx#async_action('new_multiple_files')
  nnoremap <buffer><expr> R
        \ defx#async_action('redraw')
  nnoremap <buffer><expr> v
        \ defx#async_action('toggle_select') . 'j'
  nnoremap <buffer><expr> V
        \ defx#async_action('toggle_select') . 'k'
  nnoremap <buffer> yy :let @+=expand("%:p")<cr>
endfunction
nnoremap <c-e> :Defx -search=`expand('%:p')`<cr>

" emmet
imap <expr><c-y> pumvisible() ? "\<c-y>\<Plug>(emmet-expand-abbr)" : "\<Plug>(emmet-expand-abbr)"
let g:user_emmet_expandabbr_key = '<c-y>'
let g:user_emmet_leader_key = '<c-z>'
let g:user_emmet_next_key = '<c-j>'
let g:user_emmet_prev_key = '<c-k>'

" formatter
lua << EOF
require'formatter'.setup {
  filetype = {
  },
}
EOF

" git
lua << EOF
  require'gitsigns'.setup {
    current_line_blame = true,
  }
EOF

" hop
noremap <leader>/ :HopPattern<cr>
noremap <leader>t :HopChar2<cr>
lua << EOF
  require'hop'.setup()
EOF

" indent
let g:indent_guides_enable_on_vim_startup = 1
let indent_guides_guide_size = 1

" lexima
let g:lexima_map_escape = ''

" lsp
command! LspInstalled :echo lspinstall#installed_servers()
nnoremap <leader>p :lua vim.lsp.buf.formatting()<cr>
lua << EOF
  local lsp_status = require'lsp-status'
  local lspconfig = require'lspconfig'
  local lspinstall = require'lspinstall'
  local null_ls = require'null-ls'
  local servers = lspinstall.installed_servers()
  lsp_status.config{
    status_symbol = 'lsp:',
  }
  null_ls.config {}
  lsp_status.register_progress()
  lspinstall.setup()
  lspconfig['null-ls'].setup {}
  for _, server in pairs(servers) do
    lspconfig[server].setup {
      on_attach = function(client, bufnr)
        lsp_status.on_attach(client, bufnr)
        if server == 'typescript' then
          local ts_utils = require'nvim-lsp-ts-utils'
          local opts = {}
          client.resolved_capabilities.document_formatting = false
          ts_utils.setup {
            eslint_bin = 'eslint_d',
            eslint_enable_diagnostics = true,
            enable_formatting = true,
          }
          ts_utils.setup_client(client)
          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>o', ':TSLspOrganize<cr>', opts)
        end
        vim.cmd('autocmd BufWritePost <buffer> lua vim.lsp.buf.formatting()')
      end,
      capabilities = lsp_status.capabilities,
    }
  end
EOF

" multi cursor
let g:VM_maps = {}
let g:VM_maps['Visual Cursors'] = '<c-m>'

" lightline
function! LspStatus() abort
  if luaeval('#vim.lsp.buf_get_clients() > 0')
    return luaeval('require("lsp-status").status()')
  endif
  return ''
endfunction
let g:lightline = {
      \ 'colorscheme' : 'everforest',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly', 'filename', 'modified' ],
      \             [ 'coc_status', 'lsp_status' ] ]
      \ },
      \ 'tabline': {
      \   'left': [ [ 'buffers' ] ],
      \   'right': [ [] ],
      \ },
      \ 'component_expand': {
      \   'buffers': 'lightline#bufferline#buffers',
      \ },
      \ 'component_function': {
      \   'coc_status': 'coc#status',
      \   'lsp_status': 'LspStatus',
      \ },
      \ 'component_type': {
      \   'buffers': 'tabsel',
      \ },
      \ 'component_raw': {
      \   'buffers': 1,
      \ },
      \ }
let g:lightline#bufferline#clickable = 1
let g:lightline#bufferline#shorten_path = 0
let g:lightline#bufferline#show_number = 2
nmap <Leader>0 <Plug>lightline#bufferline#go(10)
nmap <Leader>1 <Plug>lightline#bufferline#go(1)
nmap <Leader>2 <Plug>lightline#bufferline#go(2)
nmap <Leader>3 <Plug>lightline#bufferline#go(3)
nmap <Leader>4 <Plug>lightline#bufferline#go(4)
nmap <Leader>5 <Plug>lightline#bufferline#go(5)
nmap <Leader>6 <Plug>lightline#bufferline#go(6)
nmap <Leader>7 <Plug>lightline#bufferline#go(7)
nmap <Leader>8 <Plug>lightline#bufferline#go(8)
nmap <Leader>9 <Plug>lightline#bufferline#go(9)
nnoremap <leader>d :BufOnly<cr>
nnoremap <leader>x :bd<cr>

" saga
nnoremap <c-j> :Lspsaga diagnostic_jump_next<cr>
nnoremap <c-k> :Lspsaga diagnostic_jump_prev<cr>
nnoremap <leader>. :Lspsaga code_action<cr>
nnoremap <leader>gd :Lspsaga lsp_finder<cr>
nnoremap <leader>k :Lspsaga hover_doc<cr>
nnoremap <leader>r :Lspsaga rename<cr>
nnoremap gh :Lspsaga preview_definition<cr>
lua << EOF
  require'lspsaga'.init_lsp_saga {
    code_action_keys = {
      quit = '<esc>',
    },
    finder_action_keys = {
      open = '<cr>',
      quit = '<esc>',
    },
    rename_action_keys = {
      quit = '<esc>',
    },
    rename_prompt_prefix = '',
  }
EOF

" targets
autocmd User targets#mappings#user call targets#mappings#extend({
      \ 'a': {'argument': [{'o': '[{(<[]', 'c': '[]>)}]', 's': ','}]},
      \ 'b': {'pair': [{'o':'(', 'c':')'}]}
      \ })
let g:targets_seekRanges = 'cc cr cb cB lc ac Ac lr lb ar ab lB Ar aB Ab AB'

" telescope
nnoremap <c-p> <cmd>Telescope find_files theme=get_dropdown hidden=true<cr>
nnoremap <c-t> <cmd>Telescope lsp_document_symbols theme=get_dropdown<cr>
nnoremap <leader>a <cmd>Telescope buffers theme=get_dropdown<cr>
nnoremap gd :Telescope lsp_definitions theme=get_dropdown<cr>
lua << EOF
  require'telescope'.setup {
    defaults = {
      file_ignore_patterns = { '.git/.*' },
      mappings = {
        i = {
          ['<esc>'] = 'close',
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
    },
  }
EOF

" undotree
let g:undotree_SetFocusWhenToggle = 1
nnoremap <leader>u :UndotreeToggle<cr>

" word motion
let g:wordmotion_prefix = '<leader>'
