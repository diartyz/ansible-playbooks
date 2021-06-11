call plug#begin('~/.vim/plugged')

Plug 'chemzqm/wxapp.vim'
Plug 'Chiel92/vim-autoformat'
Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' } | Plug 'kristijanhusak/defx-git'
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }
Plug 'airblade/vim-gitgutter'
Plug 'arthurxavierx/vim-caser'
Plug 'chaoren/vim-wordmotion'
Plug 'diartyz/vim-utils'
Plug 'dyng/ctrlsf.vim'
Plug 'easymotion/vim-easymotion'
Plug 'itchyny/lightline.vim' | Plug 'mengelbrecht/lightline-bufferline'
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/vim-easy-align'
Plug 'kana/vim-textobj-user' | Plug 'kana/vim-textobj-entire'
Plug 'lambdalisue/suda.vim'
Plug 'machakann/vim-highlightedyank'
Plug 'mattn/emmet-vim'
Plug 'mbbill/undotree'
Plug 'mg979/vim-visual-multi'
Plug 'michaeljsmith/vim-indent-object'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'nelstrom/vim-visual-star-search'
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'ntpeters/vim-better-whitespace'
Plug 'osyo-manga/vim-over'
Plug 'roxma/nvim-yarp'
Plug 'roxma/vim-hug-neovim-rpc'
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
Plug 'w0ng/vim-hybrid'
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
command! -nargs=0 SortJson :%!jq '--sort-keys' .
command! -nargs=0 W :noautocmd w
command! OpenInVSCode exe "silent !code '" . getcwd() . "' --goto '" . expand("%") . ":" . line(".") . ":" . col(".") . "'" | redraw!
inoremap <c-o> <esc>O
let mapleader = ' '
nnoremap <leader><leader>q :q!<cr>
nnoremap <leader><leader>s :w suda://%<cr>
nnoremap <leader>d :BufOnly<cr>
nnoremap <leader>q :q<cr>
nnoremap <leader>r :source $MYVIMRC<cr>
nnoremap <leader>s :w<cr>
nnoremap <leader>x :bd<cr>
nnoremap cf :let @+=expand("%:p")<cr>
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
colorscheme hybrid
hi DiffDelete ctermfg=9
hi IndentGuidesEven ctermbg=236
hi IndentGuidesOdd ctermbg=235
hi LineNr ctermfg=240
set colorcolumn=80,120
set cul
set laststatus=2
set number
set relativenumber
set showtabline=2

" completion
call coc#add_extension(
      \ 'coc-snippets',
      \ 'coc-json',
      \ 'coc-css',
      \ 'coc-html',
      \ 'coc-wxml',
      \ 'coc-python',
      \ 'coc-tsserver',
      \ 'coc-prettier',
      \ 'coc-eslint',
      \ )
command! -nargs=0 Format :call CocActionAsync('format')
command! -nargs=? Rename :call CocActionAsync('rename', <f-args>)
inoremap <expr><c-@> coc#refresh()
inoremap <expr><c-space> coc#refresh()
inoremap <expr><tab> pumvisible() ? "\<c-y>" : "\<c-g>u\<tab>"
let g:UltiSnipsExpandTrigger = "<c-l>"
nmap <c-j> <Plug>(coc-diagnostic-next)
nmap <c-k> <Plug>(coc-diagnostic-prev)
nmap <leader>gd <Plug>(coc-references)
nmap <leader>p <Plug>(coc-format)
nmap gd <Plug>(coc-definition)
nnoremap <leader>. :call CocActionAsync('codeAction')<cr>
nnoremap <leader>k :call CocActionAsync('doHover')<cr>
nnoremap <leader>o :call CocActionAsync('runCommand', 'editor.action.organizeImport')<cr>
omap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
xmap if <Plug>(coc-funcobj-i)

" leaderf
let g:Lf_CommandMap = {'<c-j>': ['<c-n>'], '<c-k>': ['<c-p>'], '<down>': ['<c-j>'], '<up>': ['<c-k>'], '<c-p>': ['<c-l>']}
let g:Lf_PreviewInPopup = 1
let g:Lf_ShortcutB = "<leader>a"
let g:Lf_ShortcutF = "<c-p>"
let g:Lf_ShowDevIcons = 0
let g:Lf_WindowPosition = 'popup'

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
      \ 'columns': 'mark:indent:icon:filename:type:git',
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
        \ defx#async_action('toggle_select_all')
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

" indent
let g:indent_guides_auto_colors = 0
let g:indent_guides_enable_on_vim_startup = 1
let indent_guides_guide_size = 1

" multi cursor
let g:VM_maps = {}
let g:VM_maps['Visual Cursors'] = '<c-m>'

" lightline
let g:lightline = {
      \ 'tabline': {
      \   'left': [ ['buffers'] ],
      \   'right': [ [] ]
      \ },
      \ 'component_expand': {
      \   'buffers': 'lightline#bufferline#buffers'
      \ },
      \ 'component_type': {
      \   'buffers': 'tabsel'
      \ },
      \ 'component_raw': {
      \   'buffers': 1
      \ },
      \ }
let g:lightline#bufferline#clickable = 1
let g:lightline#bufferline#shorten_path = 0
let g:lightline#bufferline#show_number = 2
let s:palette = g:lightline#colorscheme#powerline#palette
let s:palette.tabline.left = [ [ '#bcbcbc', '#1c1c1c', 250, 239 ] ]
let s:palette.tabline.middle = [ [ '#4e4e4e', '#1c1c1c', 234, 239 ] ]
let s:palette.tabline.right = [ [ '#4e4e4e', '#1c1c1c', 234, 239 ] ]
let s:palette.tabline.tabsel = [ [ '#bcbcbc', '#4e4e4e', 250, 234 ] ]
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
nmap <Leader>c0 <Plug>lightline#bufferline#delete(10)
nmap <Leader>c1 <Plug>lightline#bufferline#delete(1)
nmap <Leader>c2 <Plug>lightline#bufferline#delete(2)
nmap <Leader>c3 <Plug>lightline#bufferline#delete(3)
nmap <Leader>c4 <Plug>lightline#bufferline#delete(4)
nmap <Leader>c5 <Plug>lightline#bufferline#delete(5)
nmap <Leader>c6 <Plug>lightline#bufferline#delete(6)
nmap <Leader>c7 <Plug>lightline#bufferline#delete(7)
nmap <Leader>c8 <Plug>lightline#bufferline#delete(8)
nmap <Leader>c9 <Plug>lightline#bufferline#delete(9)
unlet s:palette

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
