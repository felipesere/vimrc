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
noremap <F10> :AirlineRefresh<CR>

noremap j gj
noremap k gk
noremap gj j
noremap gk k

noremap ; :

let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline_section_b = ''
let g:airline_section_x = ''
let g:airline_section_y = ''

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 0
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_enable_elixir_checker = 1

" set leader key to comma
let mapleader = ","
map <leader>S :so $MYVIMRC <cr>

map <silent> <leader><space> :nohl<cr>
map <silent> <leader>e g_
let g:vim_markdown_folding_disabled=1
let g:NERDTreeDirArrows=0

"  eliminate white spaace
nnoremap <leader>w mz:%s/\s\+$//<cr>:let @/=''<cr>`z<cr>:w<cr>

command Q execute "qa!"

"use CTRL-P to activate find
nnoremap <silent> <C-p> :CtrlP<CR>
let g:ctrlp_user_command = 'ag %s -i --nocolor --nogroup --hidden  --ignore .git -g ""'
let g:ctrlp_match_func = {'match' : 'pymatcher#PyMatch' }
let g:ctrlp_clear_cache_on_exit = 1

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
