
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
if !exists('g:wiki_file_browser_plugin')
    let g:wiki_file_browser_plugin = 'NERDTree'
endif

let g:wiki_error = 0
" }}}
" Create and Scan Wiki Index {{{
python <<EOF
import os

wiki_index = vim.eval('g:wiki_index')
wiki_dir, wiki_file = os.path.split(wiki_index)
wiki_f_name, wiki_f_ext = os.path.splitext(wiki_file)

if not os.path.exists(wiki_dir):
    os.makedirs(wiki_dir)
elif not os.path.isdir(wiki_dir):
    vim.command('echo "%s in not a directory, wiki can not work!"' % wiki_dir)
    vim.command('let g:wiki_error = 1')

vim.command('let g:wiki_dir = "%s"' % wiki_dir)
vim.command('let g:wiki_file_ext = "%s"' % wiki_f_ext)

vim.command('autocmd BufNewFile,BufRead %s/* set ft=wiki' % wiki_dir)
EOF
" }}}
function! s:WikiChangeDir() " {{{
    exec 'cd ' . g:wiki_dir
endfunction
" }}}
function! s:WikiOpenIndex() " {{{
    call s:WikiChangeDir()
    exec join(['vi', g:wiki_index], ' ')
endfunction
" }}}
function! s:WikiOpen() " {{{
    try
        exec join([g:wiki_file_browser_plugin, g:wiki_dir], ' ')
        call s:WikiChangeDir()
    catch
        echo "NERDtree not found pleas. install NERDTree plugin"
    endtry
endfunction
" }}}
function! Wiki_Get_Fold_Level(lnum) " {{{
    let line = getline(a:lnum)

    if line =~ '^====='
        return '>1'
    elseif line =~ '^===='
        return '>2'
    elseif line =~ '^==='
        return 3
    elseif line =~ '^=='
        return 4
    elseif g:wiki_enable_fold_code && line =~ '<code.\{-}>'
        return 'a1'
    elseif g:wiki_enable_fold_code && line =~ '</code>'
        return 's1'
    else
        return '='
    endif
endfunction
" }}}
function! Wiki_Fold_Text() " {{{
    let line = getline(v:foldstart)

    if line =~ '^====='
        let level = 5
    elseif line =~ '^===='
        let level = 4
    elseif line =~ '^==='
        let level = 3
    elseif line =~ '^=='
        let level = 2
    else
        let level = ''
    endif

    let nucolwidth = &fdc + &number * &numberwidth
    let windowwidth = winwidth(0) - nucolwidth - 3
    let foldedlinecount = v:foldend - v:foldstart

    " expand tabs into spaces
    if line != ''
        let line = substitute(line, '=', '', 'g')
        let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
    endif
    let fillcharcount = windowwidth - len(line) - len(foldedlinecount) - 7
    return line . ' … '. level . repeat(" ",fillcharcount) . foldedlinecount . ' '
endfunction
" }}}
function! wiki#Open() " {{{
    call s:WikiOpen()
endfunction
" }}}
function! wiki#OpenIndex() " {{{
    call s:WikiOpenIndex()
endfunction
" }}}

command! -nargs=0 WikiOpen call wiki#Open()
command! -nargs=0 WikiOpenIndex call wiki#OpenIndex()
