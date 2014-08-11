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
set scrolloff=5                   " minimum lines above/below cursor
set laststatus=2                  " always show status bar
set nofoldenable                  " disable code folding
set clipboard=unnamed             " use the system clipboard
set wildmenu                      " enable bash style tab completion
set wildmode=list:longest,full
runtime macros/matchit.vim        " use % to jump between start/end of methods
set shortmess+=I

let g:netrw_banner=0

" set dark background and color scheme
set background=dark
colorscheme base16-railscasts

" set up some custom colors
highlight clear SignColumn
highlight VertSplit    ctermbg=236
highlight ColorColumn  ctermbg=237
highlight LineNr       ctermbg=236 ctermfg=240
highlight CursorLineNr ctermbg=236 ctermfg=226
highlight CursorLine   ctermbg=236
highlight StatusLineNC ctermbg=238 ctermfg=0
highlight StatusLine   ctermbg=240 ctermfg=12
highlight IncSearch    ctermbg=0   ctermfg=3
highlight Search       ctermbg=0   ctermfg=9
highlight Visual       ctermbg=3   ctermfg=0
highlight Pmenu        ctermbg=240 ctermfg=12
highlight PmenuSel     ctermbg=0   ctermfg=3
highlight SpellBad     ctermbg=0   ctermfg=1

" put useful info in status bar
" set statusline=%F%m%r%h%w\ %{fugitive#statusline()}\ [%l,%c]\ [%L,%p%%]
set statusline=%F%m%r%h%w\ %{fugitive#statusline()}\ [%p%%]


set pastetoggle=<F2>
let g:NumberToggleTrigger = "<F3>"

inoremap <up> <nop>
vnoremap <up> <nop>
inoremap <down> <nop>
vnoremap <down> <nop>
inoremap <left> <nop>
vnoremap <left> <nop>
inoremap <right> <nop>
vnoremap <right> <nop>
inoremap <D> <nop>
vnoremap <D> <nop>


" highlight the status bar when in insert mode
if version >= 700
  au VimEnter * hi StatusLine ctermbg=0 ctermfg=12
  au InsertEnter * hi StatusLine ctermfg=235 ctermbg=2
  au InsertLeave * hi StatusLine ctermbg=0 ctermfg=12
endif

autocmd VimEnter * NERDTree

" set leader key to comma
let mapleader = ","
map <leader>S :so $MYVIMRC<cr>

map <silent> <leader><space> :nohl<cr>

nmap ; :

"use CTRL-f to activate find
"map <C-f> :CtrlP<CR>
nnoremap <silent> <C-f> :CommandT<CR>
let g:CommandTMaxHeight=10
" unmap F1 help
nmap <F1> :echo<CR>
imap <F1> <C-o>:echo<CR>
nnoremap <silent> <F1> :NERDTreeToggle<CR>

" map . in visual mode
vnoremap . :norm.<cr>


imap <silent> <C-l> => 


" add :Plain command for converting text to plaintext
command! Plain execute "%s/’/'/ge | %s/[“”]/\"/ge | %s/—/-/ge"


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
  let l:file = expand('%')
  exec ':w'
  if match(l:file,"spec") >= 0
    call ExecuteTestInPipe(l:file)
  else
    let l:alternative = GetAlternativeFile(l:file)
    call ExecuteTestInPipe(l:alternative)
  endif
endfunction

function! ExecuteSingleLineInCurrentSpecFile()
  silent !clear
  exec ':w'
  let file = expand('%')
  let line = line('.')
  call ExecuteTestInPipe(file.":".line)
endfunction

function! ExecuteAllTestsInPipe()
  exec ':w'
  call ExecuteTestInPipe("spec")
endfunction

function! ExecuteTestInPipe(file)
  let g:file_for_last_test = a:file
  call SendToPipe('bundle exec rspec --color '.a:file)
endfunction

function! SendToPipe(line)
  if filereadable("test-commands")
    exec ':silent :!echo "clear; '.a:line.'" > test-commands'
    exec ':redraw!'
  else
    exec ':! '.a:line
  endif
endfunction

function! SendToPipeWrapper(...)
  call SendToPipe(join(a:000," "))
endfunction
command! -nargs=* Tpipe call SendToPipeWrapper(<f-args>)

function! OpenAlternativeFile()
  silent !clear
  let l:current_file = expand('%')
  let l:alternative_file = GetAlternativeFile(l:current_file)
  exec ':w'
  exec ':e '.l:alternative_file
  exec ':redraw!'
endfunction


function! GetAlternativeFile(input)
  if match(a:input,"spec") >= 0
    let l:alternative_file = substitute(a:input, "_spec.rb", ".rb", "")  
    return substitute(l:alternative_file , "spec", "lib", "")  
  else
    let l:alternative_file = substitute(a:input, ".rb", "_spec.rb", "")
    return substitute(l:alternative_file, "lib", "spec", "")
  endif
endfunction

function! RerunLastTest()
  exec ':w'
  if exists('g:file_for_last_test')
    call ExecuteTestInPipe(g:file_for_last_test)
  else
    call ExecuteAllTestsInPipe()
  endif
endfunction

map <leader>a :call OpenAlternativeFile()<cr>

map <leader>R :call ExecuteAllTestsInPipe()<cr>
map <leader>t :call ExecuteCurrentSpecFile()<cr>
map <leader>T :call ExecuteSingleLineInCurrentSpecFile()<cr>
map <leader>r :call RerunLastTest()<cr>

map <leader>co :call ToggleComments()<cr>

function! ToggleComments() range
  let l:first = line("'<")
  let l:last  = line("'>")
  let l:line = getline(l:first)
  if match(l:line, "^#") >= 0
    exec ':'.l:first.','.l:last.'s/^#//'
  else
    exec ':'.l:first.','.l:last.'s/^/#'
  endif
endfunction

