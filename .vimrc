


"""""""""" plugins

call plug#begin('~/.vim/plugged')
Plug 'sheerun/vim-polyglot'                                                 " syntax
Plug 'neoclide/coc.nvim', { 'branch': 'release' }                           " language server
Plug 'dense-analysis/ale'                                                   " linter
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }           " fuzzy search install
Plug 'junegunn/fzf.vim'                                                     " fuzzy search
Plug 'airblade/vim-gitgutter'                                               " git gutter
Plug 'itchyny/lightline.vim'                                                " status line
Plug 'tpope/vim-commentary'                                                " comments
Plug 'tpope/vim-surround'                                                   " change quotes
Plug 'tpope/vim-sleuth'                                                     " tab width based on file
Plug 'tpope/vim-unimpaired'                                                 " bracket mappings
Plug 'bluz71/vim-moonfly-colors'                                            " color scheme
Plug 'ap/vim-css-color'                                                     " highlight colors
Plug 'wakatime/vim-wakatime'                                                " time tracking
Plug 'mbbill/undotree'                                                      " undo tree
Plug 'meain/vim-printer'                                                    " print variable
Plug 'rhysd/clever-f.vim'                                                   " better f/t
Plug 'reedes/vim-pencil'                                                    " writing improvements
call plug#end()



"""""""""" vim options

let mapleader = " "                                                         " map space to leader
syntax enable                                                               " syntax highlight
colorscheme moonfly                                                         " color scheme
filetype plugin indent on                                                   " detect file type
set termguicolors                                                           " true color in terminal
set guicursor=n-v-sm:block,i-c-ci-ve:ver25,r-cr-o:hor20                     " cursor style
set splitright splitbelow                                                   " splits open on natural side
set number relativenumber                                                   " line numbers
set cursorline                                                              " highlight current line
set backspace=indent,eol,start                                              " fix backspace
set undofile undodir=~/.vim/undodir                                         " persistent undo
set list listchars=tab:»\ ,extends:›,precedes:‹,nbsp:·,trail:·,space:·      " show whitespace
set updatetime=100                                                          " faster update time
set noshowmode                                                              " hide mode in cmd line
set incsearch                                                               " search while typing
set ignorecase smartcase                                                    " case insensitive search
set encoding=utf-8                                                          " text encoding
set scrolloff=2                                                             " offset from top/bottom
set tabstop=4                                                               " tab width
set spelllang=en_us                                                         " spell check language
set wrap                                                                    " wrap text
set mouse=a                                                                 " mouse scroll
set wildmenu                                                                " autocomplete menu in cmd
set lazyredraw                                                              " redraw only when needed
set showmatch                                                               " highlight bracket pairs
autocmd FileType markdown setlocal spell                                    " spell check markdown
autocmd FileType gitcommit setlocal spell                                   " spell check git commits



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

" inc/dec number
nnoremap + <C-a>
nnoremap - <C-x>

" disable arrow keys
map <Up> <Nop>
map <Down> <Nop>
map <Left> <Nop>
map <Right> <Nop>

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
let g:gitgutter_grep = 'rg'

" lightline.vim
let g:lightline = {
      \   'colorscheme': 'moonfly',
      \ }

" clever-f.vim
let g:clever_f_smart_case = 1
let g:clever_f_fix_key_direction = 1

" vim-pencil
augroup pencil
  autocmd!
  autocmd FileType markdown call pencil#init({'wrap': 'hard', 'autoformat': 1})
  autocmd FileType text call pencil#init({'wrap': 'hard', 'autoformat': 1})
augroup END

" vim-printer
let g:vim_printer_print_below_keybinding = '<leader>l'



"""""""""" plugin mappings

" fzf.vim
nnoremap <C-p> :<C-u>Files<CR>
nnoremap <C-f> :<C-u>Rg<CR>
nnoremap <leader>p :<C-u>History<CR>
nnoremap <leader>; :<C-u>History:<CR>
nnoremap <leader>/ :<C-u>History/<CR>

" coc.nvim
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gt <Plug>(coc-type-definition)
nmap <leader>r <Plug>(coc-rename)
nmap <leader>f <Plug>(coc-fix-current)
nmap <leader>a <Plug>(coc-codeaction)

inoremap <silent><expr> <c-space> coc#refresh()
nnoremap <silent> K :call <SID>show_docs()<CR>
function! s:show_docs()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction



"""""""""""""""""""""" unformatted
" linting
let g:ale_fixers = {
      \   '*': ['remove_trailing_lines', 'trim_whitespace'],
      \ }
let g:ale_fix_on_save = 1
let g:rustfmt_autosave = 1

" undotree
let g:undotree_HighlightChangedWithSign = 0
let g:undotree_WindowLayout       = 4
let g:undotree_SetFocusWhenToggle = 1
nnoremap <leader>u :UndotreeToggle<CR>


" bind system clipboard to vim's
" set clipboard+=unnamedplus

" move lines
" nnoremap <M-j> :m .+1<CR>==
" nnoremap <M-k> :m .-2<CR>==
" vnoremap <M-j> :m '>+1<CR>gv=gv
" vnoremap <M-k> :m '<-2<CR>gv=gv

" cut only with leader
" nnoremap x "_x
" nnoremap X "_X
" nnoremap d "_d
" nnoremap D "_D
" vnoremap d "_d

" nnoremap <leader>d "+d
" nnoremap <leader>D "+D
" vnoremap <leader>d "+d

" nnoremap o o<Esc>
" nnoremap O O<Esc>

