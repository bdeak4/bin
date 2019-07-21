call plug#begin('~/.vim/plugged')

Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'

Plug 'scrooloose/nerdtree'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'haishanh/night-owl.vim'
Plug 'arcticicestudio/nord-vim'

call plug#end()

syntax enable
set termguicolors
set t_Co=256
set background=dark
" colorscheme night-owl
" let g:airline_theme='night_owl'
colorscheme nord
let g:airline_theme='nord'
let g:airline_powerline_fonts = 1

autocmd vimenter * NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
map <C-n> :NERDTreeToggle<CR>

set tabstop=4           " number of visual spaces per TAB
set softtabstop=4       " number of spaces in tab when editing
set expandtab       " tabs are spaces

set number              " show line numbers
set cursorline          " highlight current line
set lazyredraw          " redraw only when we need to.
set showmatch           " highlight matching [{()}]

set incsearch           " search as characters are entered
set hlsearch            " highlight matches
" turn off search highlight
nnoremap ,<space> :nohlsearch<CR>

set foldenable          " enable folding
set foldlevelstart=10   " open most folds by default
set foldnestmax=10      " 10 nested fold max
set foldmethod=indent   " fold based on indent level

