"" Pathogen
call pathogen#infect()  " Loads pathogen to allow easy management of plugins

set nocompatible
syntax enable
set encoding=utf-8

"" Editor display settings
set showcmd                     " display incomplete commands
set relativenumber              " show relative line numbers in the left margin
set ruler                       " show the line and column number of the cursor 
set laststatus=2                " Have every window have a status bar tied to it
color wombat                    " Default color scheme
set visualbell                  " Don't beep

"" Whitespace
set nowrap                      " don't wrap lines
set tabstop=4 shiftwidth=4      " a tab is four spaces
set expandtab                   "use spaces, not tabs
set backspace=indent,eol,start  " backspace through everything in insert mode

"" Searching
set hlsearch                " highlight matches
set incsearch               " incremental searching
set ignorecase              " searches are case insensitive...
set smartcase               " ... unless they contain at least one capital letter

" Tab completion
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc,*.class,.svn,vendor/gems/*

set cpoptions+=$            " Show a dollar on the bounds for the change command

" load the plugin and indent settings for the detected filetype
filetype plugin indent on

" Directories for swp files
set backupdir=~/.vim/backup
set directory=~/.vim/backup
