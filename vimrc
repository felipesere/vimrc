" .vimrc
"
"
" TODO: 
"  * make sure to have lua-support compiled in
"  * install unite
"  * install vimproc
"  * install vimfiler
call plug#begin('~/.vim/plugged')

  Plug 'chriskempson/base16-vim'
  Plug 'ctrlpvim/ctrlp.vim'
  Plug 'ElmCast/elm-vim'
  Plug 'octref/RootIgnore'
  Plug 'cakebaker/scss-syntax.vim'
  Plug 'bling/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'elixir-lang/vim-elixir'
  Plug 'tfnico/vim-gradle'
  Plug 'mattreduce/vim-mix'
  Plug 'tpope/vim-surround'
  Plug 'bkad/vim-terraform'
  Plug 'kchmck/vim-coffee-script'
  Plug 'mtscout6/vim-cjsx'
  Plug 'cespare/vim-toml'
  Plug 'wting/rust.vim'
  Plug 'scrooloose/nerdtree'
call plug#end()

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

let g:loaded_netrw       = 1
let g:loaded_netrwPlugin = 1
let g:netrw_banner=0

" set color scheme
colorscheme base16-default
let g:airline_theme = 'base16'

" set up some custom colors
highlight ColorColumn  ctermbg=00
highlight LineNr       ctermbg=00 ctermfg=240

set pastetoggle=<F2>
noremap <F10> :CtrlPClearCache<CR>

noremap j gj
noremap k gk
noremap gj j
noremap gk k

command Q execute "qa!"

let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline_section_b = ''
let g:airline_section_x = ''
let g:airline_section_y = ''

let g:RootIgnoreUseHome = 1

noremap <C-p> :CommandT<CR>

" set leader key to comma
let mapleader = ","
map <leader>S :so $MYVIMRC <cr>

map <silent> <leader><space> :nohl<cr>
let g:vim_markdown_folding_disabled=1

"  eliminate white spaace
nnoremap <leader>w mz:%s/\s\+$//<cr>:let @/=''<cr>`z<cr>:w<cr>

" unmap F1 help
nmap <F1> :echo<CR>
imap <F1> <C-o>:echo<CR>

nnoremap <silent> <leader>f :NERDTreeToggle<CR>
nnoremap <silent> <leader>F :NERDTreeFind<CR>

" map . in visual mode
vnoremap . :norm.<cr>


" highlight unwanted whitespace
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

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
