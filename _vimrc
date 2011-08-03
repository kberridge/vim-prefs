set nocompatible
source $VIMRUNTIME/vimrc_example.vim
source $VIMRUNTIME/mswin.vim
behave mswin

" font
set guifont=Consolas:h12:cANSI

" No menus
set guioptions-=T

" tab prefs
set expandtab
set tabstop=2
set shiftwidth=2
set smarttab

" modifies when Vim wraps text
set lbr

" indent
set ai
set si

" shows line numbers
set relativenumber

" shows matches as you type
set incsearch

" searches ignorecase if pattern is all lowercase
set ignorecase smartcase

" moves cursor to matching open symbol when you type close symbol
set showmatch

filetype on
filetype plugin on
filetype indent on
syntax on

set background=dark
"colorscheme solarized
colorscheme moria

" makes 0 go to first character on the line instead of start of line
map 0 ^

" makes jk leave insert mode (like Esc)
inoremap jk <Esc>
inoremap kj <Esc>

" Turn backup off
set nobackup

map [[ ?{<CR>w99[{

let mapleader = ","

" turns on spell checking
nmap <silent> <leader>sp :setlocal spell! spelllang=en_us<cr>

" toggles NERDTree on and off
nmap <leader>nt :NERDTreeToggle<cr>

" shortcut for alt-tabbing buffers
nmap <leader><leader> :b#<cr>

" fuzzy finder mappings
noremap <Leader>f :FufCoverageFile<CR>

" insert and delete blank lines from normal mode
nnoremap <silent><leader>S m`:silent +g/\m^\s*$/d<CR>``:noh<CR>
nnoremap <silent><leader>W m`:silent -g/\m^\s*$/d<CR>``:noh<CR>
nnoremap <silent><leader>s :set paste<CR>m`o<Esc>``:set nopaste<CR>
nnoremap <silent><leader>w :set paste<CR>m`O<Esc>``:set nopaste<CR>

" set any autocmds (make sure they are only set once)
if !exists("autocommands_loaded")
  let autocommands_loaded = 1
  
  " setup C# building
  autocmd BufNewFile,BufRead *.cs compiler devenv

  " setup folding
  autocmd BufNewFile,BufRead *.cs set foldmethod=syntax
endif

" setup integrated help
function! OnlineDoc()
  let s:wordUnderCursor = expand("<cword>")

  if &ft =~ "cs"
    let s:url = "http://social.msdn.microsoft.com/Search/en-US?query=" . s:wordUnderCursor
  else
    execute "help " . s:wordUnderCursor
    return
  endif

  let s:cmd = "silent !start chrome ".s:url

  execute s:cmd
endfunction

map <silent> <F1> :call OnlineDoc()<CR>
imap <silent> <F1> <ESC>:call OnlineDoc()<CR>

function! VsPrjAdd()
  exec 'silent !vsprj add "'.expand('%:p').'"'
endfunction
map <leader>a :call VsPrjAdd()<CR>

function! VSPrjRm()
  exec 'silent !del '.expand('%:p')
  exec 'silent !vsprj remove "'.expand('%:p').'"'
endfunction

" Nails web navigation
noremap <leader>gm :FufCoverageFile Domain\Models\<cr>
noremap <leader>gv :FufCoverageFile Website\Views\<cr>
noremap <leader>gz :FufCoverageFile Website\ViewModels\<cr>
noremap <leader>gc :FufCoverageFile Website\Controllers\<cr>
noremap <leader>ga :FufCoverageFile Website\Content\<cr>
noremap <leader>gt :FufCoverageFile Tests\<cr>

" insert relative directory of file (for namespace in C#)
"imap <leader>ns <C-R>=expand("%:h:gs?\\?\.?")<CR>
" insert file name (for class name)
"imap <leader>cs <C-R>=expand("%:t:r")<CR>

function! CsInline()
  " Delete variable type
  :normal dw
  " Copy variable name into 'a' register
  :normal "ayiw
  " Delete variable and equal sign
  :normal 2dw
  " Delete expression up to ';' into the 'b' register
  :normal "bdt;
  " Delete line
  :normal dd
  " Replace variable name with expression
  exec ':%s/\<' . @a . '\>/' . @b . '/gc'
endfunction

map ,ri :call CsInline()<CR>

" increases font size by 1pt
nnoremap <C-Up> :let &guifont = substitute(
  \ &guifont,
  \ ':h\zs\d\+',
  \ '\=eval(submatch(0)+1)',
  \ '')<CR> :redraw<CR>

" decreases font size by 1pt
nnoremap <C-Down> :let &guifont = substitute(
  \ &guifont,
  \ ':h\zs\d\+',
  \ '\=eval(submatch(0)-1)',
  \ '')<CR> :redraw<CR>

" treat cshtml files as html for syntax highlighting
au BufNewFile,BufRead *.cshtml set filetype=html

let g:ruby_path = 'C:\ruby192\bin'
