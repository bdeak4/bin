syn on
set ar cc=80 list lcs=tab:>\ ,trail:-,nbsp:+
cmap w!! w !sudo tee % > /dev/null

au BufWritePost *.ex,*.exs :sil !mix format %
au BufWritePost *.go :sil !goimports -w %
au BufWritePost *.c  :sil !indent -linux %
au BufWritePost *.py :sil !black -ql 80 %

au BufRead,BufNewFile *.ex,*.exs :setl ts=2 sw=2 et
au BufRead,BufNewFile *.py :setl ts=4 sw=4 et
