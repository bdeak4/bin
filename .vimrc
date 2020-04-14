" vim-plug automatic installation
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source ~/.vimrc
endif

" plugins
call plug#begin('~/.vim/plugged')
Plug 'dense-analysis/ale'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-abolish'
Plug 'mbbill/undotree'
Plug 'editorconfig/editorconfig-vim'
Plug 'owickstrom/vim-colors-paramount'
call plug#end()

" leader key
let mapleader = " "

" highlight
filetype plugin indent on
syntax enable
set termguicolors
set background=dark
colorscheme paramount
set colorcolumn=81
set showmatch
packadd! matchit

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
nnoremap <leader>/ :set hlsearch!<CR>

" completion
set wildmenu

" status bar
set laststatus=2
set ruler
set showcmd

" spell check
set spelllang=en,hr
autocmd FileType markdown,gitcommit setlocal spell
nnoremap <leader>s :set spell!<CR>
inoremap <C-l> <esc>[s1z=<C-o>a

" indentation
set autoindent

" show whitespace
set list listchars=tab:>\ ,trail:-,nbsp:+

" files
set hidden
set autoread

" fix backspace
set backspace=indent,eol,start

" persistent undo
if empty(glob('~/.vim/undo'))
  silent !mkdir -p ~/.vim/undo
endif
set undofile undodir=~/.vim/undo

" swap and backup
if empty(glob('~/.vim/tmp'))
  silent !mkdir -p ~/.vim/tmp
endif
set swapfile directory=~/.vim/tmp
set backup backupdir=~/.vim/tmp

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

" show registers on paste
nnoremap <leader>p :registers<CR>:normal "p<left>
nnoremap <leader>P :registers<CR>:normal "P<left>

" fix slow esc
set ttimeout ttimeoutlen=0

" fzf.vim
nnoremap <leader>f :Files<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>g :Rg<CR>
nnoremap <leader>m :Marks<CR>

" vim-gitgutter
set updatetime=100
set signcolumn=yes

" ale
let g:ale_fix_on_save = 1
let g:ale_fixers = {
  \ '*': ['remove_trailing_lines', 'trim_whitespace'],
  \ 'javascript': ['eslint', 'prettier'],
  \ 'ruby': ['standardrb'],
\}

" undotree
let g:undotree_WindowLayout = 4
let g:undotree_SetFocusWhenToggle = 1
nnoremap <leader>u :UndotreeToggle<CR>
