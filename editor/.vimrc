" auto install vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
	silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
		\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall --sync | source ~/.vimrc
endif

" plugins
call plug#begin('~/.vim/plugged')
Plug 'sheerun/vim-polyglot'
Plug 'dense-analysis/ale'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'mbbill/undotree'
Plug 'airblade/vim-rooter'
Plug 'itchyny/lightline.vim'
Plug 'chriskempson/base16-vim'
call plug#end()

" options FIXME
syntax enable
filetype plugin indent on
set backspace=indent,eol,start
set number relativenumber
set splitright splitbelow
set wildmenu

let mapleader = " "
set colorcolumn=81
set cursorline
set ttimeout ttimeoutlen=0                       " fix slow esc

set tabstop=4 shiftwidth=4
set ignorecase smartcase
set incsearch hlsearch
set hidden

if empty(glob('~/.vim/undo'))
	silent !mkdir -p ~/.vim/undo
endif
if empty(glob('~/.vim/swap'))
	silent !mkdir -p ~/.vim/swap
endif
if empty(glob('~/.vim/backup'))
	silent !mkdir -p ~/.vim/backup
endif
set undofile undodir=~/.vim/undo
set swapfile directory=~/.vim/swap
set backup backupdir=~/.vim/backup

set autoindent
set autoread
set history=10000
set showmatch

set spelllang=en,hr
set list listchars=tab:>\ ,trail:-,nbsp:+

" jump to the last known cursor position
autocmd BufReadPost *
	\ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
	\ |   exe "normal! g`\""
	\ | endif

" Create file's directory before saving, if it doesn't exist.
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

" enable spell check on files
autocmd FileType markdown,gitcommit,mail setlocal spell

" switch to normal mode
inoremap <C-l> <Esc>
vnoremap <C-l> <Esc>

" spell check
nnoremap <leader>s :setlocal spell!<CR>

" fix last spell check error
nnoremap <leader>z [s1z=

" remove search highlight
nnoremap <leader>n :nohlsearch<CR>

" insert spaces instead of tabs
nnoremap <leader>e :setlocal expandtab!<CR>

" set tab width
nnoremap <leader>2 :setlocal tabstop=2 shiftwidth=2<CR>
nnoremap <leader>4 :setlocal tabstop=4 shiftwidth=4<CR>

" fzf
nnoremap <C-t> :Files<CR>
nnoremap <leader>r :Rg<CR>

" gitgutter
set updatetime=100
set signcolumn=yes

" ale
let g:ale_completion_enabled = 1
let g:ale_fix_on_save = 1
let g:ale_fixers = {
	\ '*': ['remove_trailing_lines', 'trim_whitespace'],
	\ 'javascript': ['prettier', 'eslint'],
	\ 'typescript': ['prettier', 'eslint'],
	\ 'javascriptreact': ['prettier', 'eslint'],
	\ 'typescriptreact': ['prettier', 'eslint'],
\}
nnoremap gd :ALEGoToDefinition<CR>
nnoremap gr :ALEFindReferences<CR>
nnoremap gh :ALEHover<CR>

" undotree
let g:undotree_WindowLayout = 4
let g:undotree_SetFocusWhenToggle = 1
nnoremap <leader>u :UndotreeToggle<CR>

" lightline
set laststatus=2
set noshowmode

" base16
let base16colorspace=256
colorscheme base16-default-dark
