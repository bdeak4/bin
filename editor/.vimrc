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

" leader key
let mapleader = " "

" highlight
syntax enable
filetype plugin indent on
set cursorline
set colorcolumn=81
set showmatch

" line numbers
set number relativenumber

" splits
set splitright splitbelow

" search
set incsearch hlsearch
set ignorecase smartcase
nnoremap <leader>n :nohlsearch<CR>

" spell check
set spelllang=en,hr
nnoremap <leader>z [s1z=
nnoremap <leader>s :setlocal spell!<CR>
autocmd FileType markdown,gitcommit,mail setlocal spell

" indentation
set tabstop=4 shiftwidth=4
set autoindent
nnoremap <leader>e :setlocal expandtab!<CR>
nnoremap <leader>2 :setlocal tabstop=2 shiftwidth=2<CR>
nnoremap <leader>4 :setlocal tabstop=4 shiftwidth=4<CR>

" show whitespace
set list listchars=tab:>\ ,trail:-,nbsp:+

" command completion
set wildmenu

" files
set hidden
set autoread

" fix backspace
set backspace=indent,eol,start

" fix slow esc
set ttimeout ttimeoutlen=0

" switch to normal mode
inoremap <C-l> <Esc>
vnoremap <C-l> <Esc>

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

" fzf.vim
nnoremap <C-t> :Files<CR>
nnoremap <leader>r :Rg<CR>

" vim-gitgutter
set updatetime=100
set signcolumn=yes

" ale
let g:ale_completion_enabled = 1
let g:ale_fix_on_save = 1
let g:ale_fixers = {
	\ '*': ['remove_trailing_lines', 'trim_whitespace'],
	\ 'javascript': ['prettier', 'eslint'],
	\ 'javascriptreact': ['prettier', 'eslint'],
\}
set omnifunc=ale#completion#OmniFunc
nnoremap gd :ALEGoToDefinition<CR>
nnoremap gr :ALEFindReferences<CR>
nnoremap gh :ALEHover<CR>

" undotree
let g:undotree_WindowLayout = 4
let g:undotree_SetFocusWhenToggle = 1
nnoremap <leader>u :UndotreeToggle<CR>

" lightline.vim
set laststatus=2
set noshowmode

" base16-vim
let base16colorspace = 256
colorscheme base16-default-dark
