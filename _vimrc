set nocompatible
source $VIMRUNTIME/vimrc_example.vim
source $VIMRUNTIME/mswin.vim
behave mswin

set diffexpr=MyDiff()
function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  if &sh =~ '\<cmd'
    silent execute '!""C:\Program Files\Vim\vim70\diff" ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . '"'
  else
    silent execute '!C:\Program" Files\Vim\vim70\diff" ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
  endif
endfunction

let mapleader = ","

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
set number

" shows matches as you type
set incsearch

" searches ignorecase if pattern is all lowercase
set ignorecase smartcase

" moves cursor to matching open symbol when you type close symbol
set showmatch

" colorscheme ps_color
" colorscheme zenburn
colorscheme moria

" Vibrant Ink color scheme
" highlight Normal guifg=White   guibg=Black
" highlight Cursor guifg=Black   guibg=Yellow
" highlight Keyword guifg=#FF6600 gui=NONE
" highlight Define guifg=#FF6600 gui=NONE
" highlight Comment guifg=#9933CC gui=NONE
" highlight Type guifg=White gui=NONE
" highlight csSymbol guifg=#339999 gui=NONE
" highlight Identifier guifg=White gui=NONE
" highlight csStringDelimiter guifg=#66FF00
" highlight Constant guifg=#FFEE98 gui=NONE
" highlight Function guifg=#FFCC00 gui=NONE
" highlight Include guifg=#FFCC00 gui=NONE
" highlight Statement guifg=#FF6600 gui=NONE
" highlight String guifg=#66FF00 gui=NONE
" highlight Search guibg=White

" makes 0 go to first character on the line instead of start of line
map 0 ^

" makes jk leave insert mode (like Esc)
inoremap jk <Esc>
inoremap kj <Esc>

" Turn backup off
set nobackup

map [[ ?{<CR>w99[{

" turns on spell checking
map <F3> :setlocal spell! spelllang=en_us<cr>
imap <F3> <ESC>:setlocal spell! spelllang=en_us<cr>i

" toggles NERDTree on and off
map <F2> :NERDTreeToggle<cr>
imap <F2> <ESC>:NERDTreeToggle<cr>i

" shortcut for alt-tabbing buffers
map <M-`> :b#<cr>
imap <M-`> :b#<cr>

" set any autocmds (make sure they are only set once)
if !exists("autocommands_loaded")
  let autocommands_loaded = 1
  
  " setup C# building
  autocmd BufNewFile,BufRead *.cs compiler devenv

  " setup folding
  autocmd BufNewFile,BufRead *.cs set foldmethod=syntax
endif

" setup TFS integration
function! Tfcheckout()
  exe '!tf checkout "' expand('%:p') '"'
endfunction
command! Tfcheckout :call Tfcheckout()

function! Tfcheckin()
  exe '!tf checkin "' expand('%:p') '"'
endfunction
command! Tfcheckin :call Tfcheckin()

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
 
" find file script
function! Find(name)
  let l:_name = substitute( a:name, "\\s", "*", "g" )

  let l:files = system( "dir *".l:_name."* /B /S" )
  let l:list = split( l:files, '\n' )
  let l:len = len( l:list )

  if l:len < 1
    echo "'".a:name."' not found"
    return
  elseif l:len != 1
    let l:i = 1
    let l:cwd = substitute( getcwd(), '\\', '\\\\', "g" )

    for line in l:list
      echo l:i . ": " . substitute( l:line, l:cwd, "", "g" )
      let l:i += 1
    endfor

    let l:input = input( "Which ? (<enter>=nothing)\n" )

    if strlen( l:input ) == 0
      return
    elseif strlen( substitute( l:input, "[0-9]", "", "g" ) ) > 0
      echo "Not a number"
      return
    elseif l:input < 1 || l:input > l:len
      echo "Out of range"
      return
    endif

    let l:line = l:list[l:input-1]
  else
    let l:line = l:list[0]
  endif
  let l:line = substitute( l:line, "^[^\t]*\t./", "", "" )
  execute ":e " . l:line
endfunction

command! -nargs=1 Find :call Find("<args>")

" fuzzy finder mappings
noremap <Leader>f :FufCoverageFile<CR>
