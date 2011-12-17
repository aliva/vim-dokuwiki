
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
" }}}
" Setup Syntax Highlighting {{{
let b:current_syntax = ''
unlet b:current_syntax
syntax include @WIKI syntax/wiki.vim

"let b:current_syntax = ''
"unlet b:current_syntax
"syntax include @CODE syntax/wiki-code.vim
"syntax region CodeEmbedded matchgroup=Snip start='<code>' end='</code>' containedin=@WIKI contains=@CODE


"let b:current_syntax = ''
"unlet b:current_syntax
"syntax region CodeEmbedded matchgroup=Snip start='<code .{-}>' end='</code>' containedin=@WIKI contains=@CODE

python << EOF
# Copied from wiki:syntax#Syntax Highlighting
langs_list = vim.eval('g:wiki_inline_highlight')

for lang in langs_list:
    LANG = lang.upper()

    vim.command("let b:current_syntax = ''")

    vim.command("unlet b:current_syntax")

    vim.command("syntax include @%s syntax/%s.vim" % (LANG, lang))

    cmd  = "syntax region %sEmbedded matchgroup=Snip start='<code %s>' end='</code>'" % (LANG, lang)
    cmd += " containedin=@WIKI contains=@%s" % (LANG)
    vim.command(cmd)

langs_str = str(langs_list).replace(', ', '.')
langs_str = langs_str.replace('\'', '')

vim.command("hi link Snip SpecialComment")
vim.command("let b:current_syntax = 'wiki%s.'" % langs_str.replace)
EOF
" }}}
" Fold Functions {{{
    function! Get_Wiki_Fold_Level(lnum) " {{{
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
    function Wiki_Fold_Text() " {{{
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
" }}}
" Active Fold {{{
if g:wiki_enable_fold
    setlocal foldmethod=expr
    setlocal foldexpr=Get_Wiki_Fold_Level(v:lnum)
endif

if g:wiki_enable_set_fold_text
    setlocal foldtext=Wiki_Fold_Text()
endif
" }}}
