call plug#begin('~/.vim/plugged')

Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' } | Plug 'kristijanhusak/defx-git'
Plug 'arthurxavierx/vim-caser'
Plug 'chaoren/vim-wordmotion'
Plug 'chemzqm/wxapp.vim'
Plug 'diartyz/vim-utils'
Plug 'dyng/ctrlsf.vim'
Plug 'easymotion/vim-easymotion'
Plug 'hoob3rt/lualine.nvim'
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/vim-easy-align'
Plug 'kana/vim-textobj-entire' | Plug 'kana/vim-textobj-user'
Plug 'lambdalisue/suda.vim'
Plug 'lewis6991/gitsigns.nvim' | Plug 'nvim-lua/plenary.nvim'
Plug 'machakann/vim-highlightedyank'
Plug 'mattn/emmet-vim'
Plug 'mbbill/undotree'
Plug 'mg979/vim-visual-multi'
Plug 'michaeljsmith/vim-indent-object'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'nelstrom/vim-visual-star-search'
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'ntpeters/vim-better-whitespace'
Plug 'nvim-telescope/telescope.nvim' | Plug 'nvim-lua/popup.nvim' | Plug 'nvim-lua/plenary.nvim'
Plug 'osyo-manga/vim-over'
Plug 'romgrk/barbar.nvim' | Plug 'kyazdani42/nvim-web-devicons'
Plug 'roxma/nvim-yarp'
Plug 'roxma/vim-hug-neovim-rpc'
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
command! -nargs=0 E :e $MYVIMRC
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

" search & tab
set expandtab
set hlsearch
set ignorecase
set incsearch
set shiftround
set shiftwidth=0
set smartcase
set tabstop=2

" theme
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

" completion
call coc#add_extension(
      \ 'coc-json',
      \ 'coc-css',
      \ 'coc-html',
      \ 'coc-wxml',
      \ 'coc-python',
      \ 'coc-tsserver',
      \ 'coc-prettier',
      \ 'coc-eslint',
      \ 'coc-graphql',
      \ 'coc-vimlsp',
      \ )
inoremap <expr><c-@> coc#refresh()
inoremap <expr><c-space> coc#refresh()
inoremap <expr><tab> pumvisible() ? "\<c-y>" : "\<c-g>u\<tab>"
nmap gd <Plug>(coc-definition)
nmap <leader>gd <Plug>(coc-references)
nmap <c-j> <Plug>(coc-diagnostic-next)
nmap <c-k> <Plug>(coc-diagnostic-prev)
nmap <leader>. <Plug>(coc-codeaction-cursor)
nmap <leader>p <Plug>(coc-format)
xmap <leader>p <Plug>(coc-format-selected)
nmap <leader>r <Plug>(coc-rename)
nnoremap <leader>k :call CocActionAsync('doHover')<cr>
nnoremap <leader>o :call CocActionAsync('runCommand', 'editor.action.organizeImport')<cr>
nmap + <Plug>(coc-range-select)
xmap + <Plug>(coc-range-select)
xmap _ <Plug>(coc-range-select-backward)
omap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
xmap if <Plug>(coc-funcobj-i)

" bufferline
let bufferline = get(g:, 'bufferline', {})
let bufferline.icons = 'numbers'
let bufferline.maximum_padding = 1
nnoremap <leader>0 :BufferGoto 10<CR>
nnoremap <leader>1 :BufferGoto 1<CR>
nnoremap <leader>2 :BufferGoto 2<CR>
nnoremap <leader>3 :BufferGoto 3<CR>
nnoremap <leader>4 :BufferGoto 4<CR>
nnoremap <leader>5 :BufferGoto 5<CR>
nnoremap <leader>6 :BufferGoto 6<CR>
nnoremap <leader>7 :BufferGoto 7<CR>
nnoremap <leader>8 :BufferGoto 8<CR>
nnoremap <leader>9 :BufferGoto 9<CR>
nnoremap <leader>d :BufferCloseAllButCurrent<CR>
nnoremap <leader>x :BufferClose<CR>
nnoremap [B :BufferGoto 1<CR>
nnoremap [b :BufferPrevious<CR>
nnoremap ]B :BufferLast<CR>
nnoremap ]b :BufferNext<CR>

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

" defx
autocmd FileType defx call s:defx_my_settings()
call defx#custom#option('_', {
      \ 'columns': 'git:indent:icon:mark:filename:type',
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
  nnoremap <buffer><expr> N
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

" easymotion
map <leader>/ <Plug>(easymotion-sn)
map <leader>t <Plug>(easymotion-s2)

" emmet
imap <expr><c-y> pumvisible() ? "\<c-y>\<Plug>(emmet-expand-abbr)" : "\<Plug>(emmet-expand-abbr)"
let g:user_emmet_expandabbr_key = '<c-y>'
let g:user_emmet_leader_key = '<c-z>'
let g:user_emmet_next_key = '<c-j>'
let g:user_emmet_prev_key = '<c-k>'

" git
lua << END
require('gitsigns').setup()
END

" indent
let g:indent_guides_enable_on_vim_startup = 1
let indent_guides_guide_size = 1

" multi cursor
let g:VM_maps = {}
let g:VM_maps['Visual Cursors'] = '<c-m>'

" lualine
lua << EOF
require('lualine').setup{
  options = {
    icons_enabled = false,
    theme = 'everforest',
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch'},
    lualine_c = {'filename', 'g:coc_status'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
}
EOF

" targets
autocmd User targets#mappings#user call targets#mappings#extend({
      \ 'a': {'argument': [{'o': '[{(<[]', 'c': '[]>)}]', 's': ','}]},
      \ 'b': {'pair': [{'o':'(', 'c':')'}]}
      \ })
let g:targets_seekRanges = 'cc cr cb cB lc ac Ac lr lb ar ab lB Ar aB Ab AB'

" telescope
nnoremap <c-p> <cmd>Telescope find_files hidden=true<cr>
nnoremap <leader>a <cmd>Telescope buffers<cr>
lua << EOF
require('telescope').setup{
  defaults = {
    file_ignore_patterns = { '.git/.*' },
    mappings = {
      i = {
        ["<esc>"] = "close",
      },
    },
  },
  pickers = {
    buffers = {
      previewer = false,
      theme = "dropdown",
      mappings = {
        i = {
          ["<c-d>"] = "delete_buffer",
        },
      }
    },
    find_files = {
      theme = "dropdown"
    }
  },
}
EOF

" undotree
let g:undotree_SetFocusWhenToggle = 1
nnoremap <leader>u :UndotreeToggle<cr>

" word motion
let g:wordmotion_prefix = '<leader>'
