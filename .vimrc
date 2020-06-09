if empty(glob("~/.vim/autoload/plug.vim"))
	silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall --sync | source ~/.vimrc
endif

call plug#begin("~/.vim/plugged")
Plug 'editorconfig/editorconfig-vim'
Plug 'fatih/vim-go'
let g:go_fmt_command = "goimports"
call plug#end()

filetype plugin indent on
syntax enable
colorscheme elflord
set number relativenumber
set incsearch ignorecase smartcase
set splitright splitbelow
set wildmenu path+=**
set showcmd
set spelllang=en,hr
set list listchars=tab:>\ ,trail:-,nbsp:+
set hidden autoread
set backspace=indent,eol,start

if empty(glob("~/.vim/undo"))
	silent !mkdir -p ~/.vim/undo
endif
set undofile undodir=~/.vim/undo
set directory=~/.cache backupdir=~/.cache

autocmd BufReadPost *
	\ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
	\ | 	exe "normal! g`\""
	\ | endif

nnoremap <leader>h :set hlsearch!<CR>
nnoremap <leader>s :set spell!<CR>
nnoremap <leader>l :set list!<CR>
nnoremap <leader>c [s1z=<C-o>
nnoremap <leader>b :ls<CR>:b<space>
nnoremap <leader>p :reg<CR>:norm "p<left>
nnoremap <leader>P :reg<CR>:norm "P<left>
cmap w!! w !sudo tee % > /dev/null
