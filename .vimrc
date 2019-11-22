call plug#begin('~/.vim/plugged')

" langs
Plug 'sheerun/vim-polyglot'
" autocomplete
Plug 'neoclide/coc.nvim', {'branch': 'release'}

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)

nmap <leader>r <Plug>(coc-rename)
nmap <leader>c <Plug>(coc-codeaction)
nmap <leader>f <Plug>(coc-fix-current)

" show info
nnoremap <silent> m :call <SID>show_documentation()<CR>

function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
    else
        call CocAction('doHover')
    endif
endfunction

" open dropdown
inoremap <silent><expr> <C-space> coc#refresh()

" navigate dropdown
inoremap <C-k> <Up>
inoremap <C-j> <Down>

" linting
Plug 'dense-analysis/ale'
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace', 'prettier'],
\}
let g:ale_fix_on_save = 1
let g:rustfmt_autosave = 1

" fzf
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
nnoremap <C-p> :<C-u>Files<CR>
nnoremap <C-t> :<C-u>Tags<CR>
nnoremap <leader>f :<C-u>Rg<CR>
nnoremap <leader>p :<C-u>History<CR>
nnoremap <leader>; :<C-u>History:<CR>
nnoremap <leader>/ :<C-u>History/<CR>
nnoremap <leader>u :<C-u>BCommits<CR>
nnoremap gc :<C-u>Commits<CR>

" hide fzf status bar
autocmd! FileType fzf
autocmd  FileType fzf set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 noshowmode ruler


" colors
Plug 'arcticicestudio/nord-vim'

" highlight colors
Plug 'ap/vim-css-color'

" line numbers
set number relativenumber
Plug 'jeffkreeftmeijer/vim-numbertoggle'

" git
Plug 'airblade/vim-gitgutter'
set updatetime=100

" lightline
Plug 'itchyny/lightline.vim'
Plug 'maximbaz/lightline-ale'
set noshowmode
let g:lightline = {
    \  'colorscheme': 'nord',
    \  'separator': { 'left': "\ue0b0", 'right': "\ue0b2" },
    \  'subseparator': { 'left': "\ue0b1", 'right': "\ue0b3" },
    \  'component_expand': {
    \    'linter_checking': 'lightline#ale#checking',
    \    'linter_warnings': 'lightline#ale#warnings',
    \    'linter_errors': 'lightline#ale#errors',
    \    'linter_ok': 'lightline#ale#ok',
    \  },
    \  'component_type': {
    \    'linter_checking': 'left',
    \    'linter_warnings': 'warning',
    \    'linter_errors': 'error',
    \    'linter_ok': 'left',
    \  },
    \  'active': {
    \   'right': [ [ 'linter_checking', 'linter_errors',
    \                'linter_warnings', 'linter_ok', 'lineinfo' ],
    \              [ 'percent' ],
    \              [ 'fileformat', 'fileencoding', 'filetype' ] ]
    \  },
    \}

" multiple cursors
Plug 'terryma/vim-multiple-cursors'
let g:multi_cursor_select_all_word_key = '<C-n>a'

" spell checking
nmap <leader>z [s1z=
set spelllang=en_us
autocmd BufRead,BufNewFile *.md setlocal spell
autocmd FileType gitcommit setlocal spell

" text width
set textwidth=72
set wrap
set linebreak

" toggle comments
Plug 'scrooloose/nerdcommenter'
let g:NERDSpaceDelims = 1

" these are acctually mapped to CTRL + /
nmap <C-_>   <Plug>NERDCommenterToggle
vmap <C-_>   <Plug>NERDCommenterToggle<CR>gv

" bracket pairs
Plug 'jiangmiao/auto-pairs'

"""""""""""" testing ??????
" undo tree
" Plug 'mbbill/undotree'

Plug 'tpope/vim-surround'

" git
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
nnoremap <C-g> :<C-u>G<CR>
nnoremap gb :<C-u>Gbrowse<CR>
nnoremap gp :<C-u>Gpull<CR>
nnoremap gP :<C-u>Gpush<CR>

""""""""""""""""
call plug#end()

" disable arrow keys
cnoremap <Up> <Nop>
cnoremap <Down> <Nop>
cnoremap <Left> <Nop>
cnoremap <Right> <Nop>

inoremap <Up> <Nop>
inoremap <Down> <Nop>
inoremap <Left> <Nop>
inoremap <Right> <Nop>

nnoremap <Up> <Nop>
nnoremap <Down> <Nop>
nnoremap <Left> <Nop>
nnoremap <Right> <Nop>

vnoremap <Up> <Nop>
vnoremap <Down> <Nop>
vnoremap <Left> <Nop>
vnoremap <Right> <Nop>

" command mode navigation
cnoremap <C-k> <Up>
cnoremap <C-j> <Down>
cnoremap <C-h> <Left>
cnoremap <C-l> <Right>

" command mode without shift
nnoremap ; :
vnoremap ; :

" move to next t/f match
nnoremap , ;
vnoremap , ;

" fix common typos
command! W w
command! Q q

" easier plugin install
command! PI PlugInstall
command! PC PlugClean

" splits
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h

" file explorer
let g:netrw_banner = 0
nnoremap <leader>b :<C-u>Explore<CR>

" bind system clipboard to vim's
set clipboard+=unnamedplus

" tab width
set tabstop=4           " number of visual spaces per TAB
set softtabstop=4       " number of spaces in tab when editing
set shiftwidth=4
set expandtab           " tabs are spaces

" case insensitive search
set ignorecase
set smartcase

" splits opening on more natural side
set splitbelow
set splitright

" mouse scroll
set mouse=a

" backspace everywhere
set backspace=indent,eol,start

set cursorline          " highlight current line
set lazyredraw          " redraw only when we need to.
set scrolloff=2

set encoding=utf-8
set list
set listchars=tab:»\ ,extends:›,precedes:‹,nbsp:·,trail:·

syntax enable
set termguicolors

let g:nord_cursor_line_number_background = 1
let g:nord_underline = 1
let g:nord_italic = 1
let g:nord_italic_comments = 1

colorscheme nord

" move lines
nnoremap <M-j> :m .+1<CR>==
nnoremap <M-k> :m .-2<CR>==
vnoremap <M-j> :m '>+1<CR>gv=gv
vnoremap <M-k> :m '<-2<CR>gv=gv

" map space to leader
let mapleader = " "
let g:mapleader = " "

" cut only with leader
nnoremap x "_x
nnoremap X "_X
nnoremap d "_d
nnoremap D "_D
vnoremap d "_d

nnoremap <leader>d "+d
nnoremap <leader>D "+D
vnoremap <leader>d "+d

" don't leave insert mode on new line
nnoremap o o<Esc>
nnoremap O O<Esc>

" remove serach highlight
 nnoremap <leader>n :nohlsearch<CR>
