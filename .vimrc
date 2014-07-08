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
set cursorline                    " highlight current line
set smartcase                     " pay attention to case when caps are used
set incsearch                     " show search results as I type
set mouse=                       " enable mouse support
set ttimeoutlen=100               " decrease timeout for faster insert with 'O'
set vb                            " enable visual bell (disable audio bell)
set ruler                         " show row and column in footer
set scrolloff=2                   " minimum lines above/below cursor
set laststatus=2                  " always show status bar
set nofoldenable                  " disable code folding
set clipboard=unnamed             " use the system clipboard
set wildmenu                      " enable bash style tab completion
set wildmode=list:longest,full
runtime macros/matchit.vim        " use % to jump between start/end of methods

" put useful info in status bar
" set statusline=%F%m%r%h%w\ %{fugitive#statusline()}\ [%l,%c]\ [%L,%p%%]
set statusline=%F%m%r%h%w\ %{fugitive#statusline()}\ [%l,%c]\ [%L,%p%%]

" set dark background and color scheme
set background=dark
colorscheme base16-railscasts

" set up some custom colors
highlight clear SignColumn
highlight VertSplit    ctermbg=236
highlight ColorColumn  ctermbg=237
highlight LineNr       ctermbg=236 ctermfg=240
highlight CursorLineNr ctermbg=236 ctermfg=240
highlight CursorLine   ctermbg=236
highlight StatusLineNC ctermbg=238 ctermfg=0
highlight StatusLine   ctermbg=240 ctermfg=12
highlight IncSearch    ctermbg=0   ctermfg=3
highlight Search       ctermbg=0   ctermfg=9
highlight Visual       ctermbg=3   ctermfg=0
highlight Pmenu        ctermbg=240 ctermfg=12
highlight PmenuSel     ctermbg=0   ctermfg=3
highlight SpellBad     ctermbg=0   ctermfg=1

" highlight the status bar when in insert mode
if version >= 700
  au InsertEnter * hi StatusLine ctermfg=235 ctermbg=2
  au InsertLeave * hi StatusLine ctermbg=240 ctermfg=12
endif

" set leader key to comma
let mapleader = ","

" use JJ to hit escape and exit insert mode
:imap jj <Esc>

"use CTRL-f to activate find
:map <C-f> :CtrlP<CR>

:map <leader>s <ESC>:w<CR>

" unmap F1 help
nmap <F1> :echo<CR>
imap <F1> <C-o>:echo<CR>

" map . in visual mode
vnoremap . :norm.<cr>

" clear the command line and search highlighting
noremap <C-l> :nohlsearch<CR>

" add :Plain command for converting text to plaintext
command! Plain execute "%s/’/'/ge | %s/[“”]/\"/ge | %s/—/-/ge"

" hint to keep lines short
if exists('+colorcolumn')
  set colorcolumn=120
endif

" custom keyboard mappings:
" delete current word and get back to insert mode
:imap <C-d> <C-[>diwi<Space>


" jump to last position in file
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal g`\"" |
  \ endif

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


" executute current test file
function! ExecuteCurrentSpecFile()
  silent !clear
  let file = expand('%')
  exec ':w | :! rspec --color ' . file
endfunction

function! ExecuteSingleLineInCurrentSpecFile()
  silent !clear
  let file = expand('%')
  let line = line('.')
  exec ':w | :! rspec --color ' . file . ':' . line
endfunction

function! ExecuteAllTestsInPipe()
  exec ':w'
  exec ':silent :!echo "clear; rspec --color %" > test-commands'
  exec ':redraw!'
endfunction

function! ExecuteAlternativeSpec()
  silent !clear
  let l:current_file = expand('%')
  if match(l:current_file ,"spec") >= 0
    let l:alternative_file = substitute(l:current_file, "_spec.rb", ".rb", "")  
    let l:alternative_file = substitute(l:alternative_file , "spec", "lib", "")  
  else
    let l:alternative_file = substitute(l:current_file, ".rb", "_spec.rb", "")
    let l:alternative_file = substitute(l:alternative_file, "lib", "spec", "")
  endif
  exec ':w'
  exec ':e '.l:alternative_file
  exec ':redraw!'
endfunction

map <leader>A :call ExecuteAlternativeSpec()<cr>

map <leader>r :call ExecuteAllTestsInPipe()<cr>
map <leader>t :call ExecuteCurrentSpecFile()<cr>
map <leader>T :call ExecuteSingleLineInCurrentSpecFile()<cr>
map <leader>S :so $MYVIMRC<cr>

map <leader>h :call CreateRubyHash()<cr>
map <leader>H :call AddToRubyHash()<cr>

function! CreateRubyHash()
  let key   = input('Enter  key:')
  let value = input('Enter  value:')
  let comma = input('Enter comma')
  if empty(key) && empty(value)
    exec ':normal i {}'.comma
  else
    exec ':normal i { '.key.' => '.value.' }'.comma
  endif
endfunction

function! AddToRubyHashWithCommas(prefix, postfix)
  let pre = a:prefix
  let post = a:postfix
  let key   = input('Enter  key:')
  let value = input('Enter  value:')
  if empty(pre)
    pre=""
  endif
  if empty(post)
    post=""
  endif
  exec ':normal i '.pre.' '.key.' => '.value.' '.post
endfunction

function! AddToRubyHash()
  "let key   = input('Enter  key:')
  "let value = input('Enter  value:')
  "exec ':normal i , '.key.' => '.value
  call AddToRubyHashWithCommas("",",")
endfunction


