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
set background=light            " Ensure to have a light background
set visualbell                  " don't beep
set formatoptions=qrn1
set colorcolumn=120             " display indicator at column 120 to avoid wide lines
set t_Co=256                    "Explicitly tell vim the terminal supports 256 colors

"" Whitespace
set nowrap                                  " don't wrap lines
set tabstop=2 softtabstop=2 shiftwidth=2    " a tab is two spaces
set expandtab                               " use spaces, not tabs
set backspace=indent,eol,start              " backspace through everything 

"" Movement
" Make the tab key match bracket pairs
nnoremap <tab> %
vnoremap <tab> %
" Make tab map to auto-complete in insert mode
imap <tab> <C-p>

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

" Show whitespace similar to textmate's whitespace
set list
set listchars=eol:¬,tab:▸\ ,trail:~,extends:>,precedes:<


" Leader commands

" use comma as <leader> key
let mapleader=","

" Easier command entry
map ; :
inoremap jj <ESC>

" Splits manipulation mappings
nnoremap <leader>ma <C-w>400><C-w>400+^
nnoremap <leader>mi <C-w>400<<C-w>400-
nnoremap <leader>h <C-w>h<C-w>40>^
nnoremap <leader>l <C-w>l<C-w>40>^
nnoremap <leader>j <C-w>j<C-w>400+^
nnoremap <leader>k <C-w>k<C-w>400+^

" Search mappings
nnoremap <leader><space> :nohl<cr>

" Select the text that was just pasted
nnoremap <leader>v V`]

" Saving sessions mappings
nnoremap <F2> :mksession! ~/vim_session <cr> " Quick write session with F2
nnoremap <F3> :source ~/vim_session <cr>     " And load session with F3

" Directories for swp files
set backupdir=~/.vim/backup
set directory=~/.vim/backup

" Settings for Command-T
nmap <silent> <Leader>o :CommandTBuffer<CR>

" Settings for VimClojure
let g:HighlightBuiltins=1      " Highlight Clojure's builtins
let g:ParenRainbow=1           " Rainbow parentheses'!

" Settings for powerline
let g:Powerline_symbols = 'fancy'
