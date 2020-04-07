" vim-plug automatic installation
" source: https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source ~/.vimrc
endif

" plugins
call plug#begin('~/.vim/plugged')
Plug 'dense-analysis/ale'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-endwise'
Plug 'mbbill/undotree'
Plug 'ludovicchabant/vim-gutentags'
Plug 'editorconfig/editorconfig-vim'
Plug 'pbrisbin/vim-colors-off'
call plug#end()

" leader key
let mapleader = " "

" highlight
filetype plugin indent on
syntax enable
colorscheme off
set background=dark
set colorcolumn=81
set showmatch
packadd! matchit
" set regexpengine=1
syntax sync minlines=256

" line numbers
set number relativenumber

" splits
set splitright splitbelow
set textwidth=80 nowrap
let &winwidth = &textwidth + &numberwidth + 2

" search
set incsearch
set ignorecase smartcase
set grepprg=rg\ --vimgrep
set grepformat=%f:%l:%c:%m
nnoremap <leader>hl :set hlsearch!<CR>

" completion
set wildmenu
set wildignore+=tmp/*,log/*,vendor/*,node_modules/*,storage/*,coverage/*
for directory in split(system("echo -n */"), " ")
  if index(split(&wildignore, ","), directory . "*") == -1
    \ && index(split(&path, ","), directory . "**") == -1
    let &path .= "," . directory . "**"
  endif
endfor

" status bar
set laststatus=2
set ruler
set showcmd

" spell check
set spelllang=en,hr
autocmd FileType markdown,txt,gitcommit,mail setlocal spell
nnoremap <leader>s :set spell!<CR>
nnoremap <leader>z [s1z=<C-o>

" indentation
set autoindent

" show whitespace
set list listchars=tab:>\ ,trail:-,nbsp:+

" files
set hidden
set autoread
let g:netrw_banner = 0
let g:netrw_liststyle = 3

" fix backspace
set backspace=indent,eol,start

" persistent undo
if empty(glob('~/.vim/undo'))
  silent !mkdir -p ~/.vim/undo
endif
set undofile undodir=~/.vim/undo

" swap
if empty(glob('~/.vim/swap'))
  silent !mkdir -p ~/.vim/swap
endif
set swapfile directory=~/.vim/swap

" backup
if empty(glob('~/.vim/backup'))
  silent !mkdir -p ~/.vim/backup
endif
set backup backupdir=~/.vim/backup

" jump to the last known cursor position
autocmd BufReadPost *
  \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
  \ |   exe "normal! g`\""
  \ | endif

" create file's directory if it doesn't exist
function s:MkNonExDir(file, buf)
  if empty(getbufvar(a:buf, '&buftype')) && a:file!~#'\v^\w+\:\/'
    let dir=fnamemodify(a:file, ':h')
    if !isdirectory(dir)
      call mkdir(dir, 'p')
    endif
  endif
endfunction
augroup BWCCreateDir
  autocmd!
  autocmd BufWritePre * :call
    \ s:MkNonExDir(expand('<afile>'), +expand('<abuf>'))
augroup END

" save file with sudo
cmap w!! w !sudo tee % > /dev/null

" git blame
vnoremap gb :<C-u>!git blame <C-r>=expand("%:p")<CR>
  \ \| sed -n <C-r>=line("'<")<CR>,<C-r>=line("'>")<CR>p<CR>

" navigation shortcuts
nnoremap <leader>f :find<space>
nnoremap <leader>v :vert sfind<space>
nnoremap <leader>t :tag<space>
nnoremap <leader>g :grep<space>

" show registers/marks/buffers
nnoremap <leader>p :registers<CR>:normal "p<left>
nnoremap <leader>P :registers<CR>:normal "P<left>
nnoremap <leader>' :marks<CR>:normal '
nnoremap <leader>b :ls<CR>:b<space>

" fix command typos
command! Q q
command! W w
command! E e

" fix slow esc
set ttimeout ttimeoutlen=0

" vim-gitgutter
set updatetime=100
set signcolumn=yes

" ale
" let g:ale_fix_on_save = 1
let g:ale_fixers = {
  \ '*': ['remove_trailing_lines', 'trim_whitespace'],
  \ 'ruby': ['rubocop'],
  \ 'javascript': ['eslint', 'prettier'],
\}

" undotree
let g:undotree_WindowLayout = 4
let g:undotree_SetFocusWhenToggle = 1
nnoremap <leader>u :UndotreeToggle<CR>

" abbreviations
iabbrev medate <c-r>=strftime('%Y-%m-%d')<CR>
iabbrev meweb https://bartol.dev
iabbrev megit https://github.com/bartol
