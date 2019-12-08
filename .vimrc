"""""""""" plugins

call plug#begin('~/.vim/plugged')
Plug 'sheerun/vim-polyglot'                                       " syntax
Plug 'junegunn/fzf'                                               " fuzzy search install
Plug 'junegunn/fzf.vim'                                           " fuzzy search
Plug 'airblade/vim-gitgutter'                                     " git gutter
Plug 'itchyny/lightline.vim'                                      " status line
Plug 'tpope/vim-commentary'                                       " comments
Plug 'tpope/vim-surround'                                         " change quotes
Plug 'tpope/vim-sleuth'                                           " tab width based on file
Plug 'meain/vim-printer'                                          " print variable
Plug 'matze/vim-move'                                             " move selection
Plug 'rhysd/clever-f.vim'                                         " better f/t
Plug 'ap/vim-css-color'                                           " highlight colors
Plug 'bluz71/vim-moonfly-colors'                                  " color scheme
Plug 'wakatime/vim-wakatime'                                      " time tracking
call plug#end()



"""""""""" vim options

let mapleader = " "                                               " map space to leader
syntax enable                                                     " syntax highlight
colorscheme moonfly                                               " color scheme
filetype plugin indent on                                         " detect file type
set termguicolors                                                 " true color in terminal
set splitright splitbelow                                         " splits open on natural side
set number relativenumber                                         " line numbers
set cursorline                                                    " highlight current line
set backspace=indent,eol,start                                    " fix backspace
set undofile undodir=~/.vim/undodir                               " persistent undo
set list listchars=tab:»\ ,extends:›,precedes:‹,nbsp:·,trail:·    " show whitespace
set updatetime=100                                                " faster update time
set incsearch                                                     " search while typing
set ignorecase smartcase                                          " case insensitive search
set encoding=utf-8                                                " text encoding
set scrolloff=2                                                   " offset from top/bottom
set tabstop=4                                                     " tab width
set spelllang=en_us                                               " spell check language
set wrap                                                          " wrap text
set autoindent                                                    " autoindent new lines
set mouse=a                                                       " mouse scroll
set wildmenu                                                      " autocomplete menu in cmd
set wildmode=longest:full,full                                    " wildmenu line
set wildignore+=**/node_modules/**                                " ignore in wildmenu
set path+=**                                                      " find without full path
set lazyredraw                                                    " redraw only when needed
set showmatch                                                     " highlight bracket pairs
set hidden                                                        " hide modified file
set laststatus=2 noshowmode                                       " show status bar, hide mode
autocmd FileType markdown setlocal spell                          " spell check markdown
autocmd FileType gitcommit setlocal spell                         " spell check git commits
autocmd BufWritePre * %s/\s\+$//e                                 " remove trailing whitespace



"""""""""" vim mappings

" command mode without shift
map ; :

" splits navigation
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h

" put vim in background
nnoremap , <C-z>

" fix last spell check error
nnoremap <leader>z [s1z=

" toggle spell check
nnoremap <leader>s :setlocal spell!<CR>

" remove search highlight
nnoremap <leader>n :nohlsearch<CR>

" new line without input mode
nnoremap o o<Esc>
nnoremap O O<Esc>

" inc/dec number
nnoremap + <C-a>
nnoremap - <C-x>

" input mode navigation
inoremap <C-k> <Up>
inoremap <C-j> <Down>
inoremap <C-h> <Left>
inoremap <C-l> <Right>

" command mode navigation
cnoremap <C-k> <Up>
cnoremap <C-j> <Down>
cnoremap <C-h> <Left>
cnoremap <C-l> <Right>



"""""""""" plugin options

" fzf.vim
nnoremap <C-p> :<C-u>Files<CR>
nnoremap <C-f> :<C-u>Rg<CR>
nnoremap <C-m> :<C-u>Marks<CR>
nnoremap <leader>p :<C-u>History<CR>
nnoremap <leader>; :<C-u>History:<CR>
nnoremap <leader>/ :<C-u>History/<CR>

" vim-gitgutter
let g:gitgutter_sign_added = '▎'
let g:gitgutter_sign_modified = '▎'
let g:gitgutter_sign_removed = '▎'
let g:gitgutter_sign_modified_removed = '▎'
let g:gitgutter_sign_removed_first_line = '▎'
let g:gitgutter_sign_removed_above_and_below = '▎'

" lightline.vim
let g:lightline = { 'colorscheme': 'moonfly' }

" vim-move
let g:move_key_modifier = 'M'

" clever-f.vim
let g:clever_f_smart_case = 1
let g:clever_f_fix_key_direction = 1

" vim-printer
let g:vim_printer_print_below_keybinding = '<leader>l'

let g:vim_markdown_folding_disabled=1

" problems with regular vim:
" - slow re-rendering
" - line cursor in input mode
" - shortcuts with meta key (opt) not working
