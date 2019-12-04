



"""""""""" plugins

call plug#begin('~/.vim/plugged')
Plug 'sheerun/vim-polyglot'                                                 " language syntax
Plug 'neoclide/coc.nvim', { 'branch': 'release' }                           " language server
Plug 'dense-analysis/ale'                                                   " linter
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }           " fuzzy search install
Plug 'junegunn/fzf.vim'                                                     " fuzzy search
Plug 'airblade/vim-gitgutter'                                               " git gutter
Plug 'tpope/vim-fugitive'                                                   " git wrapper
Plug 'tpope/vim-rhubarb'                                                    " github features
Plug 'itchyny/lightline.vim'                                                " status line
Plug 'tpope/vim-commentary'                                                 " comments
Plug 'tpope/vim-surround'                                                   " change quotes
Plug 'tpope/vim-sleuth'                                                     " tab width based on file
Plug 'tpope/vim-unimpaired'                                                 " bracket mappings
Plug 'bluz71/vim-moonfly-colors'                                            " color scheme
Plug 'ap/vim-css-color'                                                     " highlight colors
Plug 'wakatime/vim-wakatime'                                                " time tracking
Plug 'jiangmiao/auto-pairs'                                                 " autocomplete brackets
Plug 'mbbill/undotree'                                                      " undo tree
Plug 'meain/vim-printer'                                                    " print variable
Plug 'rhysd/clever-f.vim'                                                   " better f/t
Plug 'janko-m/vim-test'                                                     " run tests
call plug#end()



"""""""""" vim options

let mapleader = " "                                                         " map space to leader
syntax enable                                                               " syntax highlight
set termguicolors                                                           " true color in terminal
colorscheme moonfly                                                         " color scheme
set guicursor=n-v-sm:block,i-c-ci-ve:ver25,r-cr-o:hor20                     " cursor style
set splitright splitbelow                                                   " splits open on natural side
set number relativenumber                                                   " line numbers
set cursorline                                                              " highlight current line
set undofile undodir=~/.vim/undodir                                         " persistent undo
set list listchars=tab:»\ ,extends:›,precedes:‹,nbsp:·,trail:·,space:·      " show whitespace
set updatetime=100                                                          " faster update time
set noshowmode                                                              " hide mode in cmd line



"""""""""" vim mappings

" command mode without shift
map ; :

" splits navigation
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h

" inc/dec number
nnoremap + <C-a>
nnoremap - <C-x>



"""""""""" plugin options

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



"""""""""" plugin mappings

" fzf.vim
nnoremap <C-p> :<C-u>Files<CR>
nnoremap <C-f> :<C-u>Rg<CR>
nnoremap <leader>p :<C-u>History<CR>
nnoremap <leader>; :<C-u>History:<CR>
nnoremap <leader>/ :<C-u>History/<CR>











"""""""""""""""""""""" unformatted

" autocomplete
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)

nmap <leader>r <Plug>(coc-rename)
nmap <leader>a <Plug>(coc-codeaction)
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
let g:ale_fixers = {
      \   '*': ['remove_trailing_lines', 'trim_whitespace'],
      \ }
let g:ale_fix_on_save = 1
let g:rustfmt_autosave = 1

let g:vim_printer_print_below_keybinding = '<leader>l'


" fzf
" nnoremap <C-c> :<C-u>Commits<CR>
" nnoremap <leader>u :<C-u>BCommits<CR>


" hide fzf status bar
autocmd! FileType fzf
autocmd  FileType fzf set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 noshowmode ruler



" git
let g:gitgutter_map_keys                = 0
nmap [g <Plug>(GitGutterPrevHunk)
nmap ]g <Plug>(GitGutterNextHunk)
nmap <leader>g <Plug>(GitGutterPreviewHunk)
nmap <leader>+ <Plug>(GitGutterStageHunk)
nmap <leader>- <Plug>(GitGutterUndoHunk)

" undotree
let g:undotree_HighlightChangedWithSign = 0
let g:undotree_WindowLayout       = 4
let g:undotree_SetFocusWhenToggle = 1
nnoremap <leader>u :UndotreeToggle<CR>

" run tests
let test#javascript#jest#executable = 'yarn test'
nnoremap <leader>tt :TestNearest<CR>
nnoremap <leader>tf :TestFile<CR>
nnoremap <leader>ts :TestSuite<CR>
nnoremap <leader>tl :TestLast<CR>


" lightline
" Plug 'maximbaz/lightline-ale'
      " \  'colorscheme': 'nord',
" let g:lightline = {
"     \  'colorscheme': 'moonfly',
"     \  'separator': { 'left': "\ue0b0", 'right': "\ue0b2" },
"     \  'subseparator': { 'left': "\ue0b1", 'right': "\ue0b3" },
"     \  'component_expand': {
"     \    'linter_checking': 'lightline#ale#checking',
"     \    'linter_warnings': 'lightline#ale#warnings',
"     \    'linter_errors': 'lightline#ale#errors',
"     \    'linter_ok': 'lightline#ale#ok',
"     \  },
"     \  'component_type': {
"     \    'linter_checking': 'left',
"     \    'linter_warnings': 'warning',
"     \    'linter_errors': 'error',
"     \    'linter_ok': 'left',
"     \  },
"     \  'active': {
"     \    'right': [ [ 'linter_checking', 'linter_errors',
"     \                'linter_warnings', 'linter_ok', 'lineinfo' ],
"     \              [ 'percent' ],
"     \              [ 'fileformat', 'fileencoding', 'filetype' ] ]
"     \  },
"     \}

" spell checking
nmap <leader>z [s1z=
set spelllang=en_us
" map on <C-s>
autocmd BufRead,BufNewFile *.md setlocal spell
autocmd FileType gitcommit setlocal spell

" text width
set textwidth=80
set wrap
set linebreak

"""""""""""" testing ??????


" git
nnoremap <C-g> :<C-u>G<CR>
nnoremap gb :<C-u>Gbrowse<CR>

" Plug 'ap/vim-buftabline'

""""""""""""""""


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

" fix common typos
command! W w
command! Q q

" easier plugin install
command! PI PlugInstall
command! PC PlugClean

" replace the word under cursor
nnoremap <leader>* :%s/\<<c-r><c-w>\>//g<left><left>


" tnoremap <C-j> <C-\><C-N><C-w>j
" tnoremap <C-k> <C-\><C-N><C-w>k
" tnoremap <C-l> <C-\><C-N><C-w>l
" tnoremap <C-h> <C-\><C-N><C-w>h

" tnoremap <Esc> <C-\><C-n>

" file explorer
let g:netrw_banner = 0
nnoremap <leader>f :<C-u>Explore<CR>

" bind system clipboard to vim's
set clipboard+=unnamedplus

" tab width
set tabstop=4           " number of visual spaces per TAB
" set softtabstop=4       " number of spaces in tab when editing
" set shiftwidth=4
set expandtab           " tabs are spaces

" case insensitive search
set ignorecase
set smartcase

" mouse scroll
set mouse=a

set lazyredraw          " redraw only when we need to.
set scrolloff=2

set encoding=utf-8


" let g:nord_cursor_line_number_background = 1
" let g:nord_underline = 1
" let g:nord_italic = 1
" let g:nord_italic_comments = 1

let g:moonflyCursorColor = 1


" colorscheme nord

" move lines
nnoremap <M-j> :m .+1<CR>==
nnoremap <M-k> :m .-2<CR>==
vnoremap <M-j> :m '>+1<CR>gv=gv
vnoremap <M-k> :m '<-2<CR>gv=gv

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


" auto equal splits on resize
autocmd VimResized * wincmd =

" improve scroll performance
augroup syntaxSyncMinLines
    autocmd!
    autocmd Syntax * syntax sync minlines=2000
augroup END

" remove serach highlight
 nnoremap <silent> <leader>n :nohlsearch<CR>
