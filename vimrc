syntax on

set background=dark
set encoding=utf-8

" >>> Start Powerline Settings

set rtp+=/usr/local/lib/python2.7/site-packages/powerline/bindings/vim/
set laststatus=2 "Status bar
set t_Co=256

set guifont=Inconsolata\ for\ Powerline:h15
let g:Powerline_symbols = 'fancy'
set encoding=utf-8
set t_Co=256
set fillchars+=stl:\ ,stlnc:\
set term=xterm-256color
set termencoding=utf-8

" >>> Basic Vim

set ignorecase
set paste

set wrap
set textwidth=80
set formatoptions=tcqrn1
set noshiftround

syntax enable                               " syntax highlight

set t_Co=256                                " set 256 colors

"set number                                  " show line numbers
set ruler                                   " Show file stats
set ttyfast                                 " terminal acceleration

set tabstop=4                               " 4 whitespaces for tabs visual presentation
set shiftwidth=4                            " shift lines by 4 spaces
set smarttab                                " set tabs for a shifttabs logic
set expandtab                               " expand tabs into spaces
set autoindent                              " indent when moving to the next line while writing code

set cursorline                              " shows line under the cursor's line
set showmatch                               " shows matching part of bracket pairs (), [], {}

set enc=utf-8                               " utf-8 by default

set nobackup                                " no backup files
set nowritebackup                           " only in case you don't want a backup file while editing
set noswapfile                              " no swap files

set backspace=indent,eol,start              " backspace removes all (indents, EOLs, start) What is start?

set scrolloff=10                            " let 10 lines before/after cursor during scroll

set clipboard=unnamed                       " use system clipboard

set exrc                                    " enable usage of additional .vimrc files from working directory
set secure                                  " prohibit .vimrc files to execute shell, create files, etc...

set nocompatible                            " Don't try to be vi compatible
set modelines=0                             " Security

filetype off                                " Helps force plugins to load correctly when it is turned back on below
filetype plugin indent on                   " For plugins to load correctly

" >>> TagBar settings

let g:tagbar_autofocus=0
let g:tagbar_width=42
autocmd BufEnter *.py :call tagbar#autoopen(0)
autocmd BufWinLeave *.py :TagbarClose

try
    lang es_ES
    catch
    endtry
:highlight ExtraWhitespace ctermbg=red guibg=red
:match ExtraWhitespace /\s\+$/
