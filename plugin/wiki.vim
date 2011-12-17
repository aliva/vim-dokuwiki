
" Plugin guard {{{
if exists('g:wiki_enable')
    finsih
endif
let g:wiki_enable = 1
" }}}
" Global variables {{{
if !exists('g:wiki_enable_fold')
    let g:wiki_enable_fold = 1
endif
if !exists('g:wiki_enable_fold_code')
    let g:wiki_enable_fold_code = 0
endif
if !exists('g:wiki_enable_set_fold_text')
    let g:wiki_enable_set_fold_text = 1
endif
if !exists('g:wiki_inline_highlight')
    let g:wiki_inline_highlight = ['c', 'perl']
endif
if !exists('g:wiki_index')
    let g:wiki_index = expand("$HOME") . "/.vim/wiki/start.txt"
endif
" }}}
