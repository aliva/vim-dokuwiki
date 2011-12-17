
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
" Active Fold {{{
if g:wiki_enable_fold
    setlocal foldmethod=expr
    setlocal foldexpr=Wiki_Get_Fold_Level(v:lnum)
endif

if g:wiki_enable_set_fold_text
    setlocal foldtext=Wiki_Fold_Text()
endif
" }}}
