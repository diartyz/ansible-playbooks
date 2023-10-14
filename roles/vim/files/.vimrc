call plug#begin('~/.vim/plugged')

Plug 'Shougo/defx.nvim' | Plug 'kristijanhusak/defx-git' | Plug 'kristijanhusak/defx-icons' | Plug 'roxma/vim-hug-neovim-rpc' | Plug 'roxma/nvim-yarp'
Plug 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' }
Plug 'airblade/vim-gitgutter'
Plug 'ap/vim-buftabline'
" Plug 'arthurxavierx/vim-caser'
Plug 'chaoren/vim-wordmotion'
Plug 'cohama/lexima.vim'
" Plug 'diartyz/vim-utils'
Plug 'dyng/ctrlsf.vim'
Plug 'easymotion/vim-easymotion', { 'on': '<Plug>(easymotion-overwin-f2)' }
Plug 'francoiscabrol/ranger.vim'
" Plug 'inkarkat/vim-AdvancedSorters' | Plug 'inkarkat/vim-ingo-library'
Plug 'inkarkat/vim-ReplaceWithRegister'
Plug 'junegunn/vim-easy-align'
Plug 'kana/vim-textobj-entire' | Plug 'kana/vim-textobj-user'
Plug 'machakann/vim-highlightedyank'
Plug 'lambdalisue/suda.vim'
" Plug 'mattn/emmet-vim'
Plug 'mbbill/undotree'
Plug 'mg979/vim-visual-multi'
Plug 'michaeljsmith/vim-indent-object'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'nelstrom/vim-visual-star-search'
Plug 'ntpeters/vim-better-whitespace'
Plug 'ojroques/vim-oscyank', { 'branch': 'main' }
" Plug 'osyo-manga/vim-over'
Plug 'romainl/vim-cool'
Plug 'sainnhe/everforest'
" Plug 'sgur/vim-editorconfig'
Plug 'sheerun/vim-polyglot'
Plug 'tommcdo/vim-exchange'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-obsession' | Plug 'dhruvasagar/vim-prosession'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'vim-scripts/BufOnly.vim'
Plug 'wellle/targets.vim'
Plug 'wsdjeg/vim-fetch'
" Plug 'dstein64/vim-startuptime', { 'on': 'StartupTime' }

call plug#end()

" general
set clipboard=unnamed,unnamedplus
" set fileencodings=utf-8,gb2312
" set foldlevel=99
" set foldmethod=indent
set hidden
set mouse=a
set noswapfile
" set pastetoggle=<F12>
set ttimeoutlen=0
set undodir=/tmp
set undofile
" set updatetime=300
" set wildignore=*/dist/*,*/node_modules/*
if executable('clip.exe')
  augroup WSLYank
    autocmd!
    autocmd TextYankPost * if v:event.operator ==# 'y' | call system('clip.exe', @0) | endif
  augroup END
endif

" mapping
command! -nargs=0 E :edit $MYVIMRC
command! -nargs=0 R :update|source $MYVIMRC
command! -nargs=0 Q :qa!
command! -nargs=0 W :noautocmd update
command! -nargs=0 OpenInVSCode exe "silent !code '" . getcwd() . "' --goto '" . expand("%") . ":" . line(".") . ":" . col(".") . "'" | redraw!
let mapleader = ' '
inoremap <c-a> <c-o>I
inoremap <c-e> <c-o>A
nnoremap <bs> :nohlsearch<cr>
nnoremap <c-h> :nohlsearch<cr>
nnoremap <leader><leader>q :qa!<cr>
nnoremap <leader><leader>s :x<cr>
nnoremap <leader>q :q<cr>
nnoremap <leader>s :update<cr>
nnoremap <leader>d :BufOnly<cr>
nnoremap <leader>x :bd<cr>
nnoremap cf :let @+=expand("%")<cr>
nnoremap cp :let @+=expand("%:p")<cr>

" search
set hlsearch
set ignorecase
set incsearch

" syntax
au BufRead,BufNewFile *.ets setfiletype typescript

" tab
set expandtab
set shiftround
set shiftwidth=0
set tabstop=2

" ui
set background=dark
set colorcolumn=80,120
set cursorline
set number
set termguicolors
if version>=901
  set jumpoptions=stack
endif
if has("gui_running")
  set columns=999
  set guifont=FiraCode\ Nerd\ Font\ Mono:h11
  set guioptions-=T
  set guioptions-=b
  set guioptions-=l
  set guioptions-=m
  set guioptions-=r
  set lines=999
endif

" buftabline
let g:buftabline_show = 1
let g:buftabline_numbers = 2
let g:buftabline_indicators = 1
nmap <leader>1 <Plug>BufTabLine.Go(1)
nmap <leader>2 <Plug>BufTabLine.Go(2)
nmap <leader>3 <Plug>BufTabLine.Go(3)
nmap <leader>4 <Plug>BufTabLine.Go(4)
nmap <leader>5 <Plug>BufTabLine.Go(5)
nmap <leader>6 <Plug>BufTabLine.Go(6)
nmap <leader>7 <Plug>BufTabLine.Go(7)
nmap <leader>8 <Plug>BufTabLine.Go(8)
nmap <leader>9 <Plug>BufTabLine.Go(9)
nmap <leader>0 <Plug>BufTabLine.Go(10)

" " caser
" let g:caser_prefix = '<leader>c'

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
      \ 'preview_width': 80,
      \ 'resume': 1,
      \ 'show_ignored_files': 1,
      \ 'split': 'vertical',
      \ 'vertical_preview': 1,
      \ 'winwidth': '39',
      \ })
function! s:defx_my_settings() abort
  nnoremap <buffer><expr> q
        \ defx#async_action('quit')
  nnoremap <buffer><expr> <c-e>
        \ defx#async_action('quit')
  nnoremap <buffer><expr> R
        \ defx#async_action('redraw')
  nnoremap <buffer><expr> h
        \ defx#async_action('close_tree')
  nnoremap <buffer><expr> l
        \ defx#is_directory() ?
        \ defx#async_action('open_tree') :
        \ defx#async_action('preview')
  nnoremap <buffer><expr> o
        \ defx#do_action('drop')
  nnoremap <buffer><expr> <cr>
        \ defx#async_action('multi', ['drop', 'quit'])
  nnoremap <buffer><expr> a
        \ defx#async_action('new_multiple_files')
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
  nnoremap <buffer><expr> v
        \ defx#async_action('toggle_select') . 'j'
  nnoremap <buffer><expr> C
        \ defx#async_action('clear_select_all')
  nnoremap <buffer><expr> V
        \ defx#async_action('toggle_select') . 'k'
endfunction
nnoremap <c-e> :Defx -search_recursive=`expand('%:p')`<cr>

" easyalign
nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)

" easymotion
nmap s <Plug>(easymotion-overwin-f2)
let g:EasyMotion_smartcase = 1

" " emmet
" imap <expr><c-y> pumvisible() ? "\<c-y>\<Plug>(emmet-expand-abbr)" : "\<Plug>(emmet-expand-abbr)"
" let g:user_emmet_expandabbr_key = '<c-y>'
" let g:user_emmet_leader_key = '<c-a>'
" let g:user_emmet_next_key = '<c-j>'
" let g:user_emmet_prev_key = '<c-k>'

" everforest
let g:everforest_background = 'hard'
let g:everforest_better_performance = 1
let g:everforest_diagnostic_line_highlight = 1
let g:everforest_disable_italic_comment = 1
let g:everforest_transparent_background = 1
let g:indent_guides_auto_colors = 0
colorscheme everforest
highlight Visual cterm=NONE ctermbg=241 gui=NONE guibg=#665c54

" fugitive
nnoremap <leader>gb :G blame<cr>
nnoremap <leader>gh :Gclog<cr>
xnoremap <leader>gh :Gclog<cr>

" highlightedyank
let g:highlightedyank_highlight_duration = 300

" indent
let g:indent_guides_enable_on_vim_startup = 1
let indent_guides_guide_size = 1

" leaderf
let g:Lf_CommandMap = {'<c-j>': ['<c-n>'], '<c-k>': ['<c-p>'], '<down>': ['<c-j>'], '<up>': ['<c-k>'], '<c-p>': ['<c-l>']}
let g:Lf_PreviewInPopup = 1
let g:Lf_ShortcutB = "<leader>t"
let g:Lf_ShortcutF = "<c-p>"
let g:Lf_ShowDevIcons = 1
let g:Lf_ShowHidden = 1
let g:Lf_WindowPosition = 'popup'

" lexima
let g:lexima_map_escape = ''
let g:lexima_accept_pum_with_enter = 0

" multi cursor
let g:VM_maps = {}
let g:VM_maps['Visual Cursors'] = '<c-e>'
highlight link VM_Mono DiffAdd

" oscyank
if getenv('SSH_TTY') != v:null
  let s:VimOSCYankPostRegisters = ['', '+', '*']
  function! s:VimOSCYankPostCallback(event)
    if a:event.operator == 'y' && index(s:VimOSCYankPostRegisters, a:event.regname) != -1
      call OSCYankRegister(a:event.regname)
    endif
  endfunction
  augroup VimOSCYankPost
    autocmd!
    autocmd TextYankPost * call s:VimOSCYankPostCallback(v:event)
  augroup END
endif

" ranger
let g:ranger_map_keys = 0
nnoremap + :Ranger<cr>

" targets
autocmd User targets#mappings#user call targets#mappings#extend({
      \ 'a': {'argument': [{'o': '[{(<[]', 'c': '[]>)}]', 's': ','}]},
      \ 'b': {'pair': [{'o':'(', 'c':')'}]},
      \ })
let g:targets_seekRanges = 'cc cr cb cB lc ac Ac lr lb ar ab lB Ar aB Ab AB'

" undotree
let g:undotree_SetFocusWhenToggle = 1
nnoremap <leader>u :UndotreeToggle<cr>

" wordmotion
let g:wordmotion_prefix = '<leader>'
