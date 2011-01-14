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
    let s:url = "http://social.msdn.microsoft.com/Search/en-US/?Refinement=26&Query=" . s:wordUnderCursor
  else
    execute "help " . s:wordUnderCursor
    return
  endif

  let s:browser = "\"C:\Users\kberridge\AppData\Local\Google\Chrome\Application\chrome.exe\""
  let s:cmd = "silent !start " . s:browser . " " . s:url

  execute s:cmd
endfunction

map <silent> <F1> :call OnlineDoc()<CR>
imap <silent> <F1> <ESC>:call OnlineDoc()<CR>


let g:ruby_path = 'C:\ruby192\bin'
