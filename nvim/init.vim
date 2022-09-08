"""""""""""
"  Neovim "
"""""""""""

set runtimepath+=~/.config/nvim/bundle/repos/github.com/Shougo/dein.vim

" Required:
if dein#load_state('~/.config/nvim/bundle')
  " Init
  call dein#begin('~/.config/nvim/bundle')

  " Let dein manage dein
  call dein#add('~/.config/nvim/bundle/repos/github.com/Shougo/dein.vim')

  " Plugins
  call dein#add('vim-scripts/a.vim')
  call dein#add('christoomey/vim-tmux-navigator')
  call dein#add('tomtom/tcomment_vim')
  call dein#add('scrooloose/nerdtree')
  call dein#add('tpope/vim-surround')
  call dein#add('tpope/vim-unimpaired')
  call dein#add('tpope/vim-repeat')
  call dein#add('dbakker/vim-projectroot')
  call dein#add('kien/ctrlp.vim')
  " call dein#add('ervandew/supertab')
  " call dein#add('SirVer/ultisnips')
  " call dein#add('honza/vim-snippets')

  call dein#add('morhetz/gruvbox')
  call dein#add('itchyny/lightline.vim')
  call dein#add('shinchu/lightline-gruvbox.vim')

  call dein#add('mileszs/ack.vim')
  call dein#add('dag/vim-fish')

  call dein#add('godlygeek/tabular')
  call dein#add('rust-lang/rust.vim')

  call dein#add('mhinz/vim-startify')

  " Completions
  call dein#add('Shougo/deoplete.nvim')
  if !has('nvim')
      call dein#add('roxma/nvim-yarp')
      call dein#add('roxma/vim-hug-neovim-rpc')
  endif
  let g:deoplete#enable_at_startup = 1

  " LSP (Lanugage features)
  call dein#add('prabirshrestha/async.vim')
  call dein#add('prabirshrestha/vim-lsp')

  " Snippets
  call dein#add('Shougo/neosnippet.vim')
  call dein#add('Shougo/neosnippet-snippets')
  call dein#add('thomasfaingnaert/vim-lsp-snippets')
  call dein#add('thomasfaingnaert/vim-lsp-neosnippet')

  " cleanup
  call dein#end()
  call dein#save_state()
endif

" Magic words
filetype plugin indent on
syntax enable

" Dein install on startup
if dein#check_install()
 call dein#install()
endif

" Settings
set encoding=utf-8          " Default to a modern encoding
set shiftwidth=4            " Global Default tab size (basically same as tabstop, here for backwards compatibility).
set tabstop=4               " Global Default tab size
set expandtab               " Spaces, not tabs
set number                  " Show line numbers
set nowrap                  " Don't wrap text.
set mouse=a                 " Use the mouse when supported
set ignorecase              " Searches will ignore case. Combines with...
set smartcase               " ...smartcase to allow case sensitive if search contains uppercase character.
set incsearch               " Searches performed incrementally.
set clipboard+=unnamedplus  " Make it so that yank and put use the clipboard by default.
set tags=./tags;/           " Try to find a file named "tags" searching up recusively to use with ctags.
set dir=$HOME/.vimswap//,/var/tmp//,/tmp//,.        "Keep from cluttering disk with swap files
set backupdir=$HOME/.vimbak//,/var/tmp//,/tmp//,.   "Keep from cluttering disk with backup files

" Pretties
:let $NVIM_TUI_ENABLE_TRUE_COLOR=1
set background=dark
colorscheme gruvbox

" Keys
let g:tmux_navigator_no_mappings = 1
nmap <silent> <C-h> :TmuxNavigateLeft<cr>
nmap <silent> <C-j> :TmuxNavigateDown<cr>
nmap <silent> <C-k> :TmuxNavigateUp<cr>
nmap <silent> <C-l> :TmuxNavigateRight<cr>
nmap <silent> <C-;> :TmuxNavigatePrevious<cr>

nnoremap <silent> <F6> :CtrlP<cr>
nnoremap <silent> <s-F6> :CtrlPMRU<cr>
nnoremap <silent> <c-F6> :CtrlPBuffer<cr>
nnoremap <silent> <F7> :ProjectRootExe NERDTreeToggle<cr>
nnoremap <silent> <s-F7> :ProjectRootExe NERDTreeFind<cr>


" Custom Commands
command TrimR %s/\s\+$//

" Plugin - projectroot
function! SetupProject()
    call ProjectRootCD()
    execute ':setlocal path+='.ProjectRootGuess().'/src'
    execute ':setlocal makeprg=cmake\ --build\ '.ProjectRootGuess().'/build/debug'
endfunction

let g:rootmarkers = ['tags', '.svn', '.git', 'build']
autocmd BufEnter * if &ft != 'help' | call SetupProject() | endif

" Plugin - Lightline
let g:lightline = { 
    \ 'colorscheme': 'gruvbox',
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ],
    \             [ 'readonly', 'relativepath', 'modified'] ]
    \ },
    \ 'inactive': {
    \   'left': [ [ 'relativepath', 'modified'] ]
    \ }
\ }

let g:lightline.colorscheme = 'gruvbox'

" Plugin - Ctrlp
let g:ctrlp_match_window = 'bottom,order:ttb,min:1,max:10,results:10'
let g:ctrlp_root_markers = ['tags']

" Plugin -Supertab 
let g:SuperTabDefaultCompletionType = '<C-n>'

" Plugin - Ultisnips
" let g:UltiSnipsExpandTrigger="<tab>"
" let g:UltiSnipsJumpForwardTrigger="<tab>"
" let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
" let g:snips_author="Wes Holland""

" Plugin - YouCompleteMe
" let g:ycm_auto_trigger = 1
" let g:ycm_show_diagnostics_ui = 0
" let g:ycm_always_populate_location_list = 0
" let g:ycm_collect_identifiers_from_tags_files = 0
" let g:ycm_extra_conf_globlist = ['~/code/*']
" let g:ycm_autoclose_preview_window_after_completion = 1
" let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
" let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']

" Plugin - Ack
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

" Fish shell
au BufNewFile,BufRead *.fish set filetype=fish

" LSP
if executable('rls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'rls',
        \ 'cmd': {server_info->['rustup', 'run', 'stable', 'rls']},
        \ 'workspace_config': {'rust': {'clippy_preference': 'on'}},
        \ 'whitelist': ['rust'],
        \ })
endif

" omnifuncs
augroup omnifuncs
  autocmd!
  autocmd FileType rust setlocal omnifunc=lsp#complete 
augroup end

inoremap <C-space> <C-x><C-o>

" Snippets
imap <C-i>     <Plug>(neosnippet_expand_or_jump)
smap <C-i>     <Plug>(neosnippet_expand_or_jump)
xmap <C-i>     <Plug>(neosnippet_expand_target)

imap <expr> <Tab> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<Tab>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" For conceal markers.
" if has('conceal')
"   set conceallevel=2 concealcursor=niv
" endif
