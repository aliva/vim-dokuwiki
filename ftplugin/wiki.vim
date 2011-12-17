let b:current_syntax = ''
unlet b:current_syntax
syntax include @WIKI syntax/wiki.vim

let b:current_syntax = ''
unlet b:current_syntax
syntax include @CODE syntax/wiki-code.vim
syntax region CodeEmbedded matchgroup=Snip start='<code>' end='</code>' containedin=@WIKI contains=@CODE


let b:current_syntax = ''
unlet b:current_syntax
syntax region CodeEmbedded matchgroup=Snip start='<code \.>' end='</code>' containedin=@WIKI contains=@CODE

python << EOF
# Copied from wiki:syntax#Syntax Highlighting
langs_str = "perl, c"

langs_list = langs_str.split(', ')

for lang in langs_list:
    LANG = lang.upper()

    vim.command("let b:current_syntax = ''")

    vim.command("unlet b:current_syntax")

    vim.command("syntax include @%s syntax/%s.vim" % (LANG, lang))

    cmd  = "syntax region %sEmbedded matchgroup=Snip start='<code %s>' end='</code>'" % (LANG, lang)
    cmd += " containedin=@WIKI contains=@%s" % (LANG)
    vim.command(cmd)


vim.command("hi link Snip SpecialComment")
vim.command("let b:current_syntax = 'wiki%s.'" % (langs_str.replace(', ', '.')))
EOF

setlocal foldmethod=expr
setlocal foldexpr=Wiki_Fold(v:lnum)
setlocal foldtext=Wiki_Fold_Text()


function! Wiki_Fold(lnum)
    let line = getline(a:lnum)

    if line =~ '^====='
        return '>1'
    endif
    if line =~ '^===='
        return '>2'
    endif
    if line =~ '^==='
        return 3
    endif
    if line =~ '^=='
        return 4
    endif
    return '='
endfunction

function Wiki_Fold_Text()
    let line = getline(v:foldstart)

    if line =~ '^====='
        let level = 5
    elseif line =~ '^===='
        let level = 4
    elseif line =~ '^==='
        let level = 3
    elseif line =~ '^=='
        let level = 2
    endif

    let nucolwidth = &fdc + &number * &numberwidth
    let windowwidth = winwidth(0) - nucolwidth - 3
    let foldedlinecount = v:foldend - v:foldstart

    " expand tabs into spaces
    let line = substitute(line, '=', '', 'g')
    let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
    let fillcharcount = windowwidth - len(line) - len(foldedlinecount) - 7
    return line . ' … '. level . repeat(" ",fillcharcount) . foldedlinecount . ' '
endfunction
