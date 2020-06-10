filetype plugin on
syntax enable
colorscheme elflord

set number relativenumber
set incsearch ignorecase smartcase
set splitright splitbelow
set wildmenu path+=**
set showcmd
set list listchars=tab:>\ ,trail:-,nbsp:+
set hidden autoread
set backspace=indent,eol,start
set undofile undodir=~/.vim/undo
set directory=~/.cache backupdir=~/.cache

let g:go_fmt_command = "goimports"

autocmd BufReadPost * :norm g`"<CR>

nnoremap <leader>h :set hlsearch!<CR>
nnoremap <leader>s :set spell!<CR>
nnoremap <leader>c [s1z=<C-o>
nnoremap <leader>b :ls<CR>:b<space>
nnoremap <leader>p :reg<CR>:norm "p<left>
nnoremap <leader>P :reg<CR>:norm "P<left>
nnoremap <leader>y "+y
cnoremap w!! w !sudo tee % > /dev/null

" mkdir -p ~/.vim/undo
" git clone https://github.com/fatih/vim-go ~/.vim/pack/plugins/start/vim-go
" git clone https://github.com/editorconfig/editorconfig-vim ~/.vim/pack/plugins/start/editorconfig-vim
