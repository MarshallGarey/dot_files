execute pathogen#infect()

"Auto-detect filetype.
filetype plugin indent on

" Set clipboard equal to the system clipboard so that I can use the + register
" to yank to the system clipboard
set clipboard=unnamedplus

"Highlighted serach - highlights
set hlsearch

"Syntax highlighting - figures out highlighting when opening files like with .c
syntax on

" Available colors: (search for 'cterm-colors' in this document:
" http://vimdoc.sourceforge.net/htmldoc/syntax.html)
"
" *cterm-colors*
"	    NR-16   NR-8    COLOR NAME
"	    0	    0	    Black
"	    1	    4	    DarkBlue
"	    2	    2	    DarkGreen
"	    3	    6	    DarkCyan
"	    4	    1	    DarkRed
"	    5	    5	    DarkMagenta
"	    6	    3	    Brown, DarkYellow
"	    7	    7	    LightGray, LightGrey, Gray, Grey
"	    8	    0*	    DarkGray, DarkGrey
"	    9	    4*	    Blue, LightBlue
"	    10	    2*	    Green, LightGreen
"	    11	    6*	    Cyan, LightCyan
"	    12	    1*	    Red, LightRed
"	    13	    5*	    Magenta, LightMagenta
"	    14	    3*	    Yellow, LightYellow
"	    15	    7*	    White

"My favorite color scheme
color desert
"Change highlight color. 'hi' is short for 'highlight'
highlight Search ctermbg=magenta ctermfg=grey

"Change spelling colors
hi clear SpellBad
hi SpellBad cterm=undercurl,bold
hi SpellBad ctermfg=red

"Really write out whether I have permissions
cmap w!! !sudo tee %

"Highlight and find search as you type
set incsearch

"Case insensitive
set ic

"Turn off ci when searching with captial letters
set smartcase

"Wrap lines
set wrap

"Allows you to open multiple buffers without having to write.
"It also keeps your changes history so you can undo in the buffer.
set hidden

"Use the mouse
set mouse=a

"Keep indenting of previous lines
set autoindent

"Tabs are 8 spaces
set tabstop=8

"Indent when entering new scope
set cindent

"Slurm indentation
set cinoptions=(0,u0,U0,:0
"set textwidth=80
" Disable new lines at 80 columns.
set textwidth=0

" Highlight column 81 instead of automatically creating newlines with textwidth.
hi ColorColumn ctermbg=darkgrey  guibg=lightgrey
set colorcolumn=81 "same as cc

"Moab indentation
"set cino=f1s{1s

"Number of spaces to indent when entering new scope (cindent). ex.
" if ()
" <shiftwidht>
"Also is the number of spaces to shift when using '>>' and '<<'
"set shiftwidth=2
set shiftwidth=8

"Turn tabs into spaces
"set expandtab
set noexpandtab

"Show '\' when the line wraps
set showbreak=\

"Line numbers
set number

"Show the line and column numbers of current position.
set ruler

"Briefly jump to matching bracket when inserted
set showmatch

"Puts you in paste mode
set pastetoggle=<F10>

"When opening and switching buffers tab to those opened already.
set switchbuf=useopen

"Show highlighted counts
set showcmd

"Show status line always (2=always 1=only if two windows)
set laststatus=2

" Search upward all the way to $HOME for tags so you don't have to
" open source files in the directory where ctags were generated.
"set tags+=tags;$HOME

"Highlight white space at the end of the line.
"http://vim.wikia.com/wiki/Highlight_unwanted_spaces
highlight ExtraWhitespace ctermbg=yellow guibg=yellow
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" Show/hide whitespace characters - toggle with <F3>
" https://stackoverflow.com/questions/1675688/make-vim-show-all-white-spaces-as-a-character
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<,space:.
noremap <F3> :set list!<CR>
inoremap <F3> <C-o>:set list!<CR>
cnoremap <F3> <C-o>set list!<CR>

"let g:ws_on = 0
"function! ShowWhiteSpace()
"  if g:ws_on
"    let g:ws_on = 0
"    call clearmatches()
"  else
"    let g:ws_on = 1
"    match ExtraWhitespace /\s\+$\| \+\ze\t\|[^\t]\zs\t\+\|^\t*\zs \+/
"    autocmd BufWinEnter * match ExtraWhitespace /\s\+$\| \+\ze\t\|[^\t]\zs\t\+\|^\t*\zs \+/
"    autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
"    autocmd InsertLeave * match ExtraWhitespace /\s\+$\| \+\ze\t\|[^\t]\zs\t\+\|^\t*\zs \+/
"    autocmd BufWinLeave * call clearmatches()
"  endif
"endfunction
"map <silent> <F3> :echo ShowWhiteSpace()<CR>

" From https://vi.stackexchange.com/q/454/14884
" Remove trailing whitespace
nnoremap <F5> :%s/\s\+$//e<CR>

" Wrap lines at 72 characters for git commit messages
autocmd Filetype gitcommit setlocal tw=76
"autocmd Filetype expect setlocal tw=0


"Show trailing whitespace and spaces before a tab:
"match ExtraWhitespace /\s\+$\| \+\ze\t/

" Show tabs that are not at the start of a line:
"match ExtraWhitespace /[^\t]\zs\t\+/

" Show spaces used for indenting (so you use only tabs for indenting).
"match ExtraWhitespace /^\t*\zs \+/


" When more than one match, list all matches and
" complete till longest common string.
set wildmode=list:longest

"Turn off last highlighted search.
map <F6> :nohl<CR>

"Tab complete
function! InsertTabWrapper(direction)
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<tab>"
  elseif "backward" == a:direction
    return "\<c-p>"
  else
    return "\<c-n>"
  endif
endfunction

inoremap <silent> <TAB> <c-r>=InsertTabWrapper ("backward")<cr>
inoremap <silent> <s-tab> <c-r>=InsertTabWrapper ("forward")<cr>

function! FunctionName()
  " set the flags to search backwards and not move the cursor
  let flags = "bn"
  " get the line number of the most recent function declaration
  let fNum = search('^\w\+\s\+\w\+.*\n*\s*[(){:].*[,)]*\s*$', flags)

  " paste the matching line into a variable to return
  let tempstring = getline(fNum)

  " return the line we found and what number it's on
  return "line " . fNum . ": " . tempstring
endfunction

map \func<CR> :echo FunctionName()<CR>
map <silent> <F2> :echo FunctionName()<CR>

"expands gvim to the full screen size for vdiffer
if has("gui_running")
  if (&diff)
    :set lines=60
    :set columns=180
    set cc=81
  endif
endif


" Close buffer without closing split window
" http://stackoverflow.com/a/8585343/839788
map <leader>q :bp<bar>sp<bar>bn<bar>bd<CR>

" Since I'm lazy, map this so I don't have to press shift and enter
map ;q :q<CR>

" Be able to run aliases from cmd
" Bash must needs interactive
"set shellcmdflag=-ic

" Switch tabs with F7 and F8
map <F7> :tabp<CR>
map <F8> :tabn<CR>
" Switch buffers with F9 and F10
map <F9> :bp<CR>
map <F10> :bn<CR>

" Center screen on next/previous selection.
"nnoremap n nzz
"nnoremap N Nzz
" Last and next jump should center too.
"nnoremap <C-o> <C-o>zz
"nnoremap <C-i> <C-i>zz

" When using * to highlight word under cursor, don't jump to next search result
" and don't add to jump stack. See the comments to the accepted answer to this
" StackOverflow question:
" https://stackoverflow.com/questions/4256697/vim-search-and-highlight-but-do-not-jump
nnoremap * :keepjumps normal! mi*`i<cr>

" Be able to use tags when I'm in a child of the directory that tags is in.
" Traverse up to my home directory looking for a tags file.
" https://stackoverflow.com/a/741486/4880288
set tags=./tags;/
"set csrelative
"set tags+=tags;$HOME

" How to remap the escape key:
" http://ergoemacs.org/emacs/vi_remap_escape_key.html
" Make home key do esc when in insertion mode
":imap <Home> <Esc>
