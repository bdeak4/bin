""" plugins

call plug#begin('~/.config/nvim/plugged')
Plug 'sheerun/vim-polyglot'                                       " syntax
Plug 'dense-analysis/ale'                                         " linter
Plug 'junegunn/fzf'                                               " fuzzy search install
Plug 'junegunn/fzf.vim'                                           " fuzzy search
Plug 'airblade/vim-gitgutter'                                     " git
Plug 'itchyny/lightline.vim'                                      " status line
Plug 'tpope/vim-commentary'                                       " comments
Plug 'tpope/vim-surround'                                         " change quotes
Plug 'tpope/vim-sleuth'                                           " tab width based on file
Plug 'meain/vim-printer'                                          " print variable
Plug 'rhysd/clever-f.vim'                                         " better f/t
Plug 'mbbill/undotree'                                            " undo tree
Plug 'chriskempson/base16-vim'                                    " color scheme
Plug 'ap/vim-css-color'                                           " highlight colors
call plug#end()


""" vim options

let mapleader = " "                                               " map space to leader
syntax enable                                                     " syntax highlight
colorscheme base16-default-dark                                   " color scheme
set termguicolors                                                 " true color in terminal
set splitright splitbelow                                         " splits open on natural side
set number relativenumber                                         " line numbers
set cursorline                                                    " highlight current line
set undofile                                                      " persistent undo
set list listchars=tab:»\ ,extends:›,precedes:‹,nbsp:·,trail:·    " show whitespace
set updatetime=100                                                " faster update time
set ignorecase smartcase                                          " case insensitive search
set scrolloff=3                                                   " offset from top/bottom
set tabstop=4                                                     " tab width
set signcolumn=yes                                                " always show sign column
set spelllang=en_us                                               " spell check language
set wrap                                                          " wrap text
set mouse=a                                                       " mouse scroll
set lazyredraw                                                    " redraw only when needed
set showmatch                                                     " highlight bracket pairs
set hidden                                                        " hide modified file
set laststatus=2 noshowmode                                       " show status bar, hide mode
autocmd FileType markdown setlocal spell                          " spell check markdown
autocmd FileType gitcommit setlocal spell                         " spell check git commits

" command mode without shift
nnoremap ; :

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

" replacement for multiple cursors
nnoremap <silent> * :let @/='\<'.expand('<cword>').'\>'<CR>cgn
xnoremap <silent> * "sy:let @/=@s<CR>cgn

" new line without input mode
nnoremap <CR> m`o<Esc>``
nnoremap <S-CR> m`O<Esc>``

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

" disable arrow keys
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

" todos
nmap \c m`^rx:r! date +"<Space>[\%H:\%M]"<CR>kJ``
nmap \u m`^r_$F<Space>"_D``
nmap \t o<Esc>0i<Space><Space>_<Space>
nmap \d ggO<Esc>:r! date +"\%Y/\%m/\%d"<CR>kJo<CR><CR><CR><Esc>kkk\t


""" plugin options

" fzf.vim
nnoremap <C-t> :<C-u>Files<CR>
nnoremap <C-f> :<C-u>Rg<CR>
nnoremap <leader>t :<C-u>History<CR>
nnoremap <leader>; :<C-u>History:<CR>
nnoremap <leader>/ :<C-u>History/<CR>

autocmd! FileType fzf
autocmd  FileType fzf set laststatus=0
  \| autocmd BufLeave <buffer> set laststatus=2


" vim-gitgutter
let g:gitgutter_sign_added = '▎'
let g:gitgutter_sign_modified = '▎'
let g:gitgutter_sign_removed = '▎'
let g:gitgutter_sign_modified_removed = '▎'
let g:gitgutter_sign_removed_first_line = '▎'
let g:gitgutter_sign_removed_above_and_below = '▎'

" ale
let g:ale_fix_on_save = 1
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'javascript': ['prettier', 'eslint'],
\}
nnoremap gd :<C-u>ALEGoToDefinition<CR>
nnoremap gr :<C-u>ALEFindReferences<CR>
nnoremap gh :<C-u>ALEHover<CR>

" undotree
let g:undotree_WindowLayout = 4
let g:undotree_SetFocusWhenToggle = 1
nnoremap <leader>u :<C-u>UndotreeToggle<CR>

" clever-f.vim
let g:clever_f_smart_case = 1

" base16-vim
let base16colorspace=256

" vim-polygot
let g:vim_markdown_folding_disabled=1
