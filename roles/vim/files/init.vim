call plug#begin('~/.vim/plugged')

" Plug 'jose-elias-alvarez/null-ls.nvim'
" Plug 'jose-elias-alvarez/nvim-lsp-ts-utils'
" Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}
" Plug 'ms-jpq/coq.thirdparty', {'branch': '3p'}
" Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
" Plug 'neovim/nvim-lspconfig'
" Plug 'williamboman/nvim-lsp-installer'
Plug 'JoosepAlviste/nvim-ts-context-commentstring'
Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' } | Plug 'kristijanhusak/defx-git' | Plug 'kristijanhusak/defx-icons'
Plug 'SirVer/ultisnips'
Plug 'arthurxavierx/vim-caser'
Plug 'chaoren/vim-wordmotion'
Plug 'chemzqm/wxapp.vim'
Plug 'cohama/lexima.vim'
Plug 'diartyz/vim-utils'
function! InstallNvimSortJson(info)
  !yarn install --frozen-lockfile
  execute ':UpdateRemotePlugins'
endfunction
Plug 'diartyz/nvim-sort-json', { 'do': function('InstallNvimSortJson') }
Plug 'dyng/ctrlsf.vim'
Plug 'folke/todo-comments.nvim' | Plug 'nvim-lua/plenary.nvim'
Plug 'francoiscabrol/ranger.vim'
Plug 'github/copilot.vim'
Plug 'inkarkat/vim-AdvancedSorters' | Plug 'inkarkat/vim-ingo-library'
Plug 'inkarkat/vim-ReplaceWithRegister'
Plug 'itchyny/lightline.vim' | Plug 'mengelbrecht/lightline-bufferline'
Plug 'junegunn/vim-easy-align'
Plug 'kana/vim-textobj-entire' | Plug 'kana/vim-textobj-user'
Plug 'kdheepak/lazygit.nvim'
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
Plug 'nvim-telescope/telescope.nvim' | Plug 'nvim-lua/plenary.nvim' | Plug 'kyazdani42/nvim-web-devicons'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'osyo-manga/vim-over'
Plug 'phaazon/hop.nvim'
Plug 'rbgrouleff/bclose.vim'
Plug 'sainnhe/everforest'
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
set undodir=/tmp
set undofile
set updatetime=300
set wildignore=*/dist/*,*/node_modules/*

" mapping
command! -nargs=0 E :edit $MYVIMRC
command! -nargs=0 Jq :%!jq '--sort-keys'
command! -nargs=0 R :source $MYVIMRC
command! -nargs=0 W :noautocmd w
command! OpenInVSCode exe "silent !code '" . getcwd() . "' --goto '" . expand("%") . ":" . line(".") . ":" . col(".") . "'" | redraw!
inoremap <c-o> <esc>O
let mapleader = ' '
nnoremap <bs> :nohlsearch<cr>
nnoremap <c-h> :nohlsearch<cr>
nnoremap <leader><leader>q :q!<cr>
nnoremap <leader><leader>s :w suda://%<cr>
nnoremap <leader>d :BufOnly<cr>
nnoremap <leader>q :q<cr>
nnoremap <leader>s :w<cr>
nnoremap <leader>x :Bclose<cr>
nnoremap cp :let @+=expand("%")<cr>

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
set termguicolors
hi Visual cterm=NONE ctermbg=241 gui=NONE guibg=#665c54

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

" coc
call coc#add_extension(
      \ 'coc-tabnine',
      \ 'coc-snippets',
      \ 'coc-json',
      \ 'coc-css',
      \ 'coc-html',
      \ 'coc-wxml',
      \ 'coc-tsserver',
      \ 'coc-prettier',
      \ 'coc-eslint',
      \ 'coc-vimlsp',
      \ )
inoremap <expr><c-@> coc#refresh()
inoremap <expr><c-space> coc#refresh()
inoremap <expr><tab> pumvisible() ? coc#_select_confirm() : "\<c-g>u\<tab>"
let g:UltiSnipsExpandTrigger = "<c-;>"
nmap gd <Plug>(coc-definition)
nmap <leader>gd <Plug>(coc-references)
nmap gp <Plug>(coc-format)
xmap gp <Plug>(coc-format-selected)
nmap <c-j> <Plug>(coc-diagnostic-next)
nmap <c-k> <Plug>(coc-diagnostic-prev)
nmap <leader>. <Plug>(coc-codeaction-cursor)
nmap <leader>r <Plug>(coc-rename)
nnoremap gh :call CocActionAsync('doHover')<cr>
nnoremap go :call CocActionAsync('runCommand', 'editor.action.organizeImport')<cr>
omap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
xmap if <Plug>(coc-funcobj-i)

" " coq
" let g:coq_settings = {
"       \ 'auto_start': 'shut-up',
"       \ 'clients.buffers.enabled': v:false,
"       \ 'clients.snippets.enabled': v:false,
"       \ 'clients.tabnine.enabled': v:false,
"       \ 'clients.tmux.enabled': v:false,
"       \ 'display.ghost_text.enabled': v:false,
"       \ 'display.pum.fast_close': v:false,
"       \ 'keymap.recommended': v:false,
"       \ }
" ino <expr><tab> pumvisible() ? (complete_info().selected == -1 ? "\<C-e><tab>" : "\<C-y>") : "\<tab>"
" nn <c-j> <cmd>lua vim.lsp.diagnostic.goto_next()<CR>
" nn <c-k> <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
" nn <leader>. <cmd>lua vim.lsp.buf.code_action()<CR>
" nn <leader>gd <cmd>lua vim.lsp.buf.references()<CR>
" nn <leader>r <cmd>lua vim.lsp.buf.rename()<CR>
" nn gd <cmd>lua vim.lsp.buf.definition()<CR>
" nn gh <cmd>lua vim.lsp.buf.hover()<CR>
" nn go :TSLspOrganize<CR>
" nn gp <cmd>lua vim.lsp.buf.formatting()<CR>
" lua << EOF
" local coq = require'coq'
" local lsp_installer = require'nvim-lsp-installer'
" local null_ls = require'null-ls'
" local ts_utils = require'nvim-lsp-ts-utils'
" lsp_installer.on_server_ready(function(server)
"   local opts = {}
"   if server.name == 'tsserver' then
"     opts.init_options = ts_utils.init_options
"     opts.on_attach = function(client, bufnr)
"       client.resolved_capabilities.document_formatting = false
"       client.resolved_capabilities.document_range_formatting = false
"       ts_utils.setup({
"         auto_inlay_hints = false,
"       })
"       ts_utils.setup_client(client)
"     end
"   end
"   server:setup(coq.lsp_ensure_capabilities(opts))
" end)
" null_ls.setup({
"   sources = {
"     null_ls.builtins.diagnostics.eslint_d,
"     null_ls.builtins.code_actions.eslint_d,
"     null_ls.builtins.formatting.prettierd,
"   },
" })
" EOF

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
  nnoremap <buffer><expr> o
	      \ defx#do_action('preview')
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

" gitsigns
lua << EOF
  require('gitsigns').setup {
    current_line_blame = true,
    update_debounce = 300,
    signs = {
      add          = {hl = 'GitSignsAdd',    text = '+', numhl = 'GitSignsAddNr',    linehl = 'GitSignsAddLn'},
      change       = {hl = 'GitSignsChange', text = '~', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn'},
      changedelete = {hl = 'GitSignsChange', text = '|', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn'},
    },
    on_attach = function(bufnr)
      local function map(mode, lhs, rhs, opts)
          opts = vim.tbl_extend('force', {noremap = true, silent = true}, opts or {})
          vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
      end

      map('n', '[c', "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", {expr=true})
      map('n', ']c', "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", {expr=true})
      map('n', '<leader>hr', ':Gitsigns reset_hunk<CR>')
      map('v', '<leader>hr', ':Gitsigns reset_hunk<CR>')
      map('n', '<leader>hs', ':Gitsigns stage_hunk<CR>')
      map('v', '<leader>hs', ':Gitsigns stage_hunk<CR>')
      map('o', 'ih', ':<C-U>Gitsigns select_hunk<CR>')
      map('x', 'ih', ':<C-U>Gitsigns select_hunk<CR>')
    end
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

" lazygit
let g:lazygit_floating_window_scaling_factor = 1
nnoremap <c-l> :LazyGit<cr>

" lexima
let g:lexima_map_escape = ''
let g:lexima_accept_pum_with_enter = 0

" multi cursor
let g:VM_maps = {}
let g:VM_maps['Visual Cursors'] = '<c-l>'

" lightline
let g:lightline = {
      \ 'colorscheme' : 'everforest',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly', 'filename', 'modified' ],
      \             [ 'coc_status' ] ]
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

" ranger
let g:ranger_map_keys = 0
nnoremap - :Ranger<cr>

" sort json
let g:sort_json = {
      \ 'orderOverride': [
      \   'name',
      \   'private',
      \   'version',
      \   'main',
      \   'module',
      \   'types',
      \   'typings',
      \   'files',
      \   'publishConfig',
      \   'repository',
      \   'scripts'
      \ ],
      \ 'orderUnderride': [
      \   'resolutions',
      \   'dependencies',
      \   'devDependencies',
      \   'peerDependencies',
      \   'source.organizeImports'
      \ ],
      \ }

" targets
autocmd User targets#mappings#user call targets#mappings#extend({
      \ 'a': {'argument': [{'o': '[{(<[]', 'c': '[]>)}]', 's': ','}]},
      \ 'b': {'pair': [{'o':'(', 'c':')'}]},
      \ })
let g:targets_seekRanges = 'cc cr cb cB lc ac Ac lr lb ar ab lB Ar aB Ab AB'

" telescope
nnoremap <c-p> <cmd>Telescope find_files<cr>
nnoremap <c-t> <cmd>Telescope current_buffer_fuzzy_find<cr>
nnoremap <leader>a <cmd>Telescope buffers<cr>
lua << EOF
  require'telescope'.setup {
    defaults = require'telescope.themes'.get_dropdown{
      file_ignore_patterns = { '^./.git/.*' },
      mappings = {
        i = {
          ['<esc>'] = 'close',
          ["<c-j>"] = require('telescope.actions').cycle_history_next,
          ["<c-k>"] = require('telescope.actions').cycle_history_prev,
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
EOF

" todo
nnoremap <leader>p :TodoTelescope<cr>
lua << EOF
  require'todo-comments'.setup {
    highlight = {
      keyword = 'bg',
      pattern = [[<(KEYWORDS)>]],
    },
    search = {
      pattern = [[\b(KEYWORDS)\b]],
    },
  }
EOF

" treesitter
lua << EOF
require'nvim-treesitter.configs'.setup {
  context_commentstring = {
    enable = true,
  },
  ensure_installed = {
    "javascript",
    "typescript",
    "tsx",
  },
}
EOF

" undotree
let g:undotree_SetFocusWhenToggle = 1
nnoremap <leader>u :UndotreeToggle<cr>

" word motion
let g:wordmotion_prefix = '<leader>'
