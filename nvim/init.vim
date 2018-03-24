"""""""""""
"  Neovim "
"""""""""""

set runtimepath+=/Users/wholland/.config/nvim/bundle/repos/github.com/Shougo/dein.vim

" Required:
if dein#load_state('/Users/wholland/.config/nvim/bundle')
  " Init
  call dein#begin('/Users/wholland/.config/nvim/bundle')

  " Let dein manage dein
  call dein#add('/Users/wholland/.config/nvim/bundle/repos/github.com/Shougo/dein.vim')

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
  call dein#add('ervandew/supertab')
  call dein#add('SirVer/ultisnips')
  call dein#add('honza/vim-snippets')

  call dein#add('morhetz/gruvbox')
  call dein#add('itchyny/lightline.vim')
  call dein#add('shinchu/lightline-gruvbox.vim')

  call dein#add('mileszs/ack.vim')
  call dein#add('dag/vim-fish')

  "TODO Add guards for unsupported platforms
  " call dein#add('Valloric/YouCompleteMe')

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
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
let g:snips_author="Wes Holland""

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
