"" Pathogen
call pathogen#infect()  " loads pathogen to allow easy management of plugins

set nocompatible
syntax enable
set encoding=utf-8

" Load the plugin and indent settings for the detected filetype
filetype plugin indent on

"" Setting to make crontab editing work by not saving a backup file
au! BufNewFile,BufRead crontab.* set nobackup | set nowritebackup

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
inoremap <tab> <C-p>

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

" Abbreviations
iabbrev @@ aslong87@gmail.com
iabbrev ccopy Copyright 2012 Andrew Long, all rights reserved.

" Leader commands

" use comma as <leader> key
let mapleader=","

" Quick CoffeeCompile
nnoremap <leader>cc :CoffeeCompile<cr>

" NERDTree FilePane
nnoremap <leader>n :NERDTreeToggle<CR>

" Move line up or down
nnoremap - ddp
nnoremap _ ddkP

" Easier editing of this file
nnoremap <leader>ev :vsp $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

" Easier file reload
nnoremap <leader>r :e %<cr>

" Easier quit pane
nnoremap <leader>q :q<cr>

" Easier upper case word currently under cursor
inoremap <C-u> <esc>lwbvwUel<esc>i
nnoremap <C-u> wbvwUel<esc>

" Better end and beginning of line movements
nnoremap <leader>H ^
nnoremap <leader>L $

" Easier command entry
noremap ; :
inoremap kj <esc>
inoremap <esc> <nop>

" Tabs mappings
"nnoremap <leader>n :tabnew<cr>
nnoremap <leader>l gt
nnoremap <leader>h gT

" Splits mappings
nnoremap <leader>v :vsp<cr>
nnoremap <leader>b :sp<cr>

" Splits manipulation mappings
nnoremap <leader>ma <C-w>400><C-w>400+^
nnoremap <leader>mi <C-w>400<<C-w>400-
nnoremap <leader>j <C-w>j<C-w>400+^
nnoremap <leader>k <C-w>k<C-w>400+^

" Search and spelling mappings
nnoremap <leader><space> :nohl<cr>:set nospell<cr>
nnoremap <leader>sp :set spell spelllang=en_us<cr>

" Select the text that was just pasted
nnoremap <leader>pp V`]

" Saving sessions mappings
nnoremap <F2> :mksession! ~/vim_session <cr> " Quick write session with F2
nnoremap <F3> :source ~/vim_session <cr>     " And load session with F3

" Directories for swp files
set backupdir=~/.vim/backup
set directory=~/.vim/backup

function! Git_Repo_Cdup() " Get the relative path to repo root
    "Ask git for the root of the git repo (as a relative '../../' path)
    let git_top = system('git rev-parse --show-cdup')
    let git_fail = 'fatal: Not a git repository'
    if strpart(git_top, 0, strlen(git_fail)) == git_fail
        " Above line says we are not in git repo. Ugly. Better version?
        return ''
    else
        " Return the cdup path to the root. If already in root,
        " path will be empty, so add './'
        return './' . git_top
    endif
endfunction

" Allows you to cd to the root of a git repo
function! CD_Git_Root()
    execute 'cd '.Git_Repo_Cdup()
    let curdir = getcwd()
    echo 'CWD now set to: '.curdir
endfunction
nnoremap <leader>gr :call CD_Git_Root()<cr>

" Define the wildignore from gitignore. Primarily for CommandT
function! WildignoreFromGitignore()
    silent call CD_Git_Root()
    let gitignore = '.gitignore'
    if filereadable(gitignore)
        let igstring = ''
        for oline in readfile(gitignore)
            let line = substitute(oline, '\s|\n|\r', '', "g")
            if line =~ '^#' | con | endif
            if line == '' | con  | endif
            if line =~ '^!' | con  | endif
            if line =~ '/$' | let igstring .= "," . line . "**" | con | endif
            let igstring .= "," . line
        endfor
        let execstring = "set wildignore=".substitute(igstring,'^,','',"g")
        execute execstring
        echo 'Wildignore defined from gitignore in: '.getcwd()
        echo execstring
    else
        echo 'Unable to find gitignore'
    endif
endfunction

nnoremap <leader>wi :call WildignoreFromGitignore()<cr>
nnoremap <leader>cwi :set wildignore=''<cr>:echo 'Wildignore cleared'<cr>

" Mappings for Command-T
nnoremap <silent> <leader>o :CommandTBuffer<CR>
nnoremap <silent> <leader>ctf :CommandTFlush<CR>

" Settings for VimClojure
let g:HighlightBuiltins=1      " Highlight Clojure's builtins
let g:ParenRainbow=1           " Rainbow parentheses'!

" Settings for powerline
let g:Powerline_symbols = 'fancy'

" Text manipulation

  " Align all selected code on '=' sign
function! AlignAssign() range

  let max_col = 0
  for text in getline('<, '>)
    let pos = match(text, '\s*=')
    if pos != -1
      let max_col = max([max_col, pos])
    endif
  endfor

  for line in range('<, '>)
    let text = getline(line)
    let pos  = match(text, '\s*=')
    if pos != -1
      call setpos('.', [0, line, pos+1, 0])
      execute "normal" "i \e" . "dt=" . (max_col - pos + 1) . "i "
    endif
  endfor

endfunction

vnoremap <leader>a :call AlignAssign()<cr>
