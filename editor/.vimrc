" auto install vim-plug
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
Plug 'tpope/vim-eunuch'
" Plug 'tpope/vim-rails'
Plug 'tpope/vim-endwise'
Plug 'mbbill/undotree'
Plug 'ludovicchabant/vim-gutentags'
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
nnoremap <leader>z [s1z=
nnoremap <leader>s :setlocal spell!<cr>
autocmd FileType markdown,txt,gitcommit,mail setlocal spell

" indentation
set tabstop=4 shiftwidth=4
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
" cmap w!! w !sudo tee % > /dev/null

" show registers on paste or jump to mark
nnoremap <leader>p :registers<cr>:normal "p<left>
nnoremap <leader>P :registers<cr>:normal "P<left>
nnoremap <leader>' :marks<cr>:normal '
nnoremap <leader>l :ls<cr>:b<space>

" vim-gitgutter
set updatetime=100
set signcolumn=yes

" ale
let g:ale_fix_on_save = 1
let g:ale_fixers = {
	\ '*': ['remove_trailing_lines', 'trim_whitespace'],
	\ 'ruby': ['rubocop'],
	\ 'javascript': ['eslint', 'prettier'],
\}

" undotree
let g:undotree_WindowLayout = 4
let g:undotree_SetFocusWhenToggle = 1
nnoremap <leader>u :UndotreeToggle<cr>

" abbreviations
iabbrev medate <c-r>=strftime('%Y-%m-%d')<cr>
iabbrev meweb https://bartol.dev
iabbrev megit https://github.com/bartol
