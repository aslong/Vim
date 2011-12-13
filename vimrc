"" Pathogen
call pathogen#infect()  " loads pathogen to allow easy management of plugins

set nocompatible
syntax enable
set encoding=utf-8

" Load the plugin and indent settings for the detected filetype
filetype plugin indent on

"" Editor display settings
set showcmd                     " display incomplete commands
set relativenumber              " show relative line numbers in the left margin
set ruler                       " show the line and column number of the cursor 
set laststatus=2                " have every window have a status bar tied to it
color wombat                    " default color scheme
set visualbell                  " don't beep
set formatoptions=qrn1
set colorcolumn=100             " display indicator at column 100 to avoid wide lines

"" Whitespace
set nowrap                                  " don't wrap lines
set tabstop=4 softtabstop=4 shiftwidth=4    " a tab is four spaces
set expandtab                               " use spaces, not tabs
set backspace=indent,eol,start              " backspace through everything 

"" Movement
" Make the tab key match bracket pairs
nnoremap <tab> %
vnoremap <tab> %

"" Searching

" Default to using normal regexes by automatically inserting
" \v before the any string you search for.
nnoremap / /\v
vnoremap / /\v
set hlsearch                " highlight matches
set incsearch               " incremental searching
set ignorecase              " searches are case insensitive...
set smartcase               " ... unless they contain at least one capital letter

" Tab completion
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc,*.class,.svn,vendor/gems/*

" Misc settings
set cpoptions+=$            " Show a dollar on the bounds for the change command
set modelines=0             " Turn off modelines since I don't use them and they 
                            " have security exploits

" Leader commands

" Select the text that was just pasted
nnoremap <leader>v V`]

" Directories for swp files
set backupdir=~/.vim/backup
set directory=~/.vim/backup
