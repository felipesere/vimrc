" .vimrc

" load up pathogen and all bundles
call pathogen#infect()
call pathogen#helptags()

scriptencoding utf-8
set encoding=utf-8

syntax on                         " show syntax highlighting
filetype plugin indent on
set backspace=indent,eol,start    " respect backspace
set autoindent                    " set auto indent
set ts=2                          " set indent to 2 spaces
set shiftwidth=2
set expandtab                     " use spaces, not tab characters
set nocompatible                  " don't need to be compatible with old vim
set number                        " show the absolute number as well
set showmatch                     " show bracket matches
set ignorecase                    " ignore case in search
set hlsearch                      " highlight all search matches
set cursorline                    " highlight current line (DISABLED)
set nocursorcolumn
set nofoldenable                  " disable code folding
set smartcase                     " pay attention to case when caps are used
set incsearch                     " show search results as I type
set mouse=                        " enable mouse support
set ttimeoutlen=100               " decrease timeout for faster insert with 'O'
set vb                            " enable visual bell (disable audio bell)
set scrolloff=5                   " minimum lines above/below cursor
set laststatus=2                  " always show status bar
set clipboard=unnamed             " use the system clipboard
set wildmenu                      " enable bash style tab completion
set wildmode=list:longest,full
runtime macros/matchit.vim        " use % to jump between start/end of methods
set shortmess+=I
set noswapfile

let g:netrw_banner=0

" set dark background and color scheme
set background=dark
colorscheme base16-default

" set up some custom colors
"highlight clear SignColumn
highlight VertSplit    ctermbg=00
highlight ColorColumn  ctermbg=00
highlight LineNr       ctermbg=00 ctermfg=240
highlight SignColumn   ctermbg=00 ctermfg=240

set pastetoggle=<F2>
let g:NumberToggleTrigger = "<F3>"
noremap <F4> :CommandTFlush<CR>
noremap <F10> :AirlineRefresh<CR>

inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

vnoremap <up> <nop>
vnoremap <down> <nop>
vnoremap <left> <nop>
vnoremap <right> <nop>

nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>

noremap j gj
noremap k gk
noremap gj j
noremap gk k

noremap ; :

nmap <silent> <c-k> :wincmd k<CR>
nmap <silent> <c-j> :wincmd j<CR>
nmap <silent> <c-h> :wincmd h<CR>
nmap <silent> <c-l> :wincmd l<CR>

let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline_section_b = ''
let g:airline_section_x = ''
let g:airline_section_y = ''

" set leader key to comma
let mapleader = ","
map <leader>S :so $MYVIMRC <cr>

map <silent> <leader><space> :nohl<cr>
map <silent> <leader>e g_
let g:vim_markdown_folding_disabled=1
let g:NERDTreeDirArrows=0

let g:goyo_width=120

function! s:goyo_enter()
  Limelight0.7
  let b:quitting = 0
  let b:quitting_bang = 0
  autocmd QuitPre <buffer> let b:quitting = 1
  cabbrev <buffer> q! let b:quitting_bang = 1 <bar> q!
  set scrolloff=999
endfunction

function! s:goyo_leave()
  set scrolloff=5
  Limelight!
  " Quit Vim if this is the only remaining buffer
  if b:quitting && len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) == 1
    if b:quitting_bang
      qa!
    else
      qa
    endif
  endif
endfunction

autocmd! User GoyoEnter
autocmd! User GoyoLeave
autocmd User GoyoEnter call <SID>goyo_enter()
autocmd User GoyoLeave call <SID>goyo_leave()

"  eliminate white spaace
nnoremap <leader>w mz:%s/\s\+$//<cr>:let @/=''<cr>`z<cr>:w<cr>

command Q execute "qa!"

"use CTRL-f to activate find
nnoremap <silent> <C-p> :CommandT<CR>
let g:CommandTMaxHeight=10
let g:CommandTMatchWindowReverse=1
let g:COmmandTAcceptSelectionSplitMap=['<CR>','<C-h>']

" unmap F1 help
nmap <F1> :echo<CR>
imap <F1> <C-o>:echo<CR>

nnoremap <silent> <F1> :NERDTreeToggle<CR>

" map . in visual mode
vnoremap . :norm.<cr>

" multi-purpose tab key (auto-complete)
function! InsertTabWrapper()
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<tab>"
  else
    return "\<c-p>"
  endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>
inoremap <s-tab> <c-n>

" rename current file, via Gary Bernhardt
function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'))
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
endfunction
map <leader>n :call RenameFile()<cr>

