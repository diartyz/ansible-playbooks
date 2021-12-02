call plug#begin('~/.vim/plugged')

Plug 'AndrewRadev/tagalong.vim'
Plug 'Shougo/defx.nvim' | Plug 'kristijanhusak/defx-git' | Plug 'kristijanhusak/defx-icons' | Plug 'roxma/vim-hug-neovim-rpc' | Plug 'roxma/nvim-yarp'
Plug 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' }
Plug 'airblade/vim-gitgutter'
Plug 'arthurxavierx/vim-caser'
Plug 'chaoren/vim-wordmotion'
Plug 'chemzqm/wxapp.vim'
Plug 'cohama/lexima.vim'
Plug 'diartyz/vim-utils'
Plug 'dyng/ctrlsf.vim'
Plug 'inkarkat/vim-AdvancedSorters' | Plug 'inkarkat/vim-ingo-library'
Plug 'inkarkat/vim-ReplaceWithRegister'
Plug 'junegunn/vim-easy-align'
Plug 'kana/vim-textobj-entire' | Plug 'kana/vim-textobj-user'
Plug 'lambdalisue/suda.vim'
Plug 'machakann/vim-highlightedyank'
Plug 'mattn/emmet-vim'
Plug 'mbbill/undotree'
Plug 'mg979/vim-visual-multi'
Plug 'michaeljsmith/vim-indent-object'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'nelstrom/vim-visual-star-search'
Plug 'ntpeters/vim-better-whitespace'
Plug 'osyo-manga/vim-over'
Plug 'sgur/vim-editorconfig'
Plug 'sheerun/vim-polyglot'
Plug 'tommcdo/vim-exchange'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-obsession' | Plug 'dhruvasagar/vim-prosession'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'vim-scripts/BufOnly.vim'
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
set updatetime=300
set wildignore=*/dist/*,*/node_modules/*

" mapping
command! -nargs=0 E :edit $MYVIMRC
command! -nargs=0 R :source $MYVIMRC
command! -nargs=0 SortJson :%!jq '--sort-keys'
command! -nargs=0 W :noautocmd w
command! OpenInVSCode exe "silent !code '" . getcwd() . "' --goto '" . expand("%") . ":" . line(".") . ":" . col(".") . "'" | redraw!
inoremap <c-o> <esc>O
let mapleader = ' '
nnoremap <leader><leader>q :q!<cr>
nnoremap <leader><leader>s :w suda://%<cr>
nnoremap <leader>d :BufOnly!<cr>
nnoremap <leader>q :q<cr>
nnoremap <leader>s :w<cr>
nnoremap <leader>x :bd!<cr>
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
set colorcolumn=80,120
set cul
set laststatus=0
set number
set relativenumber
set showtabline=0

" ctrlsf
let g:ctrlsf_auto_focus = {
      \ 'at' : 'start',
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
  nnoremap <buffer><expr> cc
        \ defx#async_action('rename')
  nnoremap <buffer><expr> dd
        \ defx#async_action('move')
  nnoremap <buffer><expr> yy
        \ defx#async_action('copy')
  nnoremap <buffer><expr> cp
        \ defx#do_action('yank_path')
  nnoremap <buffer><expr> p
        \ defx#async_action('paste')
  nnoremap <buffer><expr> D
        \ defx#async_action('remove_trash', ['force'])
  nnoremap <buffer><expr> M
        \ defx#async_action('new_multiple_files')
  nnoremap <buffer><expr> R
        \ defx#async_action('redraw')
  nnoremap <buffer><expr> v
        \ defx#async_action('toggle_select') . 'j'
  nnoremap <buffer><expr> V
        \ defx#async_action('toggle_select') . 'k'
endfunction
nnoremap <c-e> :Defx -search_recursive=`expand('%:p')`<cr>

" easyalign
nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)

" emmet
imap <expr><c-y> pumvisible() ? "\<c-y>\<Plug>(emmet-expand-abbr)" : "\<Plug>(emmet-expand-abbr)"
let g:user_emmet_expandabbr_key = '<c-y>'
let g:user_emmet_leader_key = '<c-z>'
let g:user_emmet_next_key = '<c-j>'
let g:user_emmet_prev_key = '<c-k>'

" indent
let g:indent_guides_enable_on_vim_startup = 1
let indent_guides_guide_size = 1

" leaderf
let g:Lf_CommandMap = {'<c-j>': ['<c-n>'], '<c-k>': ['<c-p>'], '<down>': ['<c-j>'], '<up>': ['<c-k>'], '<c-p>': ['<c-l>']}
let g:Lf_PreviewInPopup = 1
let g:Lf_ShortcutB = "<leader>a"
let g:Lf_ShortcutF = "<c-p>"
let g:Lf_ShowDevIcons = 1
let g:Lf_WindowPosition = 'popup'

" lexima
let g:lexima_map_escape = ''

" multi cursor
let g:VM_maps = {}
let g:VM_maps['Visual Cursors'] = '<c-m>'

" targets
autocmd User targets#mappings#user call targets#mappings#extend({
      \ 'a': {'argument': [{'o': '[{(<[]', 'c': '[]>)}]', 's': ','}]},
      \ 'b': {'pair': [{'o':'(', 'c':')'}]}
      \ })
let g:targets_seekRanges = 'cc cr cb cB lc ac Ac lr lb ar ab lB Ar aB Ab AB'

" undotree
let g:undotree_SetFocusWhenToggle = 1
nnoremap <leader>u :UndotreeToggle<cr>

" word motion
let g:wordmotion_prefix = '<leader>'
