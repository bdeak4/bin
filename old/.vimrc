filetype indent plugin on

set nu rnu

"set number relativenumber
set incsearch ignorecase smartcase
set splitright splitbelow
set wildmenu path+=**
set showcmd
set list listchars=tab:>\ ,trail:-,nbsp:+
set hidden autoread
set undofile undodir=~/.vim/undo
set directory=~/.cache

nmap <leader>h :set hlsearch!<CR>
nmap <leader>s :set spell!<CR>
nmap <leader>b :ls<CR>:b<space>
nmap <leader>p :reg<CR>:norm "p<left>
nmap <leader>P :reg<CR>:norm "P<left>
nmap <leader>y "+y
cmap w!! w !sudo tee % > /dev/null

" mkdir -p ~/.vim/undo
" git clone https://github.com/editorconfig/editorconfig-vim ~/.vim/pack/plugins/start/editorconfig-vim
