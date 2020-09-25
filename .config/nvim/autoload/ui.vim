function! ui#statusline() abort
    let s = '%<%f%m%r%h%w  %='

    " if &fileencoding != ''
    "     let s .= printf('[%s]', &fileencoding)
    " endif

    " if &filetype != ''
    "     let s .= printf('[%s]', &filetype)
    " endif

    let s .= '[%{&fileencoding}][%{&filetype}][%l/%L,%c]'
    return s
endfunction

function! ui#tabline() abort
    let s = ''

    for i in range(tabpagenr('$'))
        if i + 1 == tabpagenr()
            let s .= '%#TabLineSel#'
        else
            let s .= '%#TabLine#'
        endif

        if i + 1 == tabpagenr()
            let s .= '%#TabLineSel#' " WildMenu
        else
            let s .= '%#Title#'
        endif

        " set the tab page number (for mouse clicks)
        let s .= '%' . (i + 1) . 'T '

        " set page number string
        let s .= i + 1 . ''

        " get buffer names and statuses
        let n = ''  " temp str for buf names
        let m = 0   " &modified counter
        let buflist = tabpagebuflist(i + 1)

        " loop through each buffer in a tab
        for b in buflist
            if getbufvar(b, "&buftype") == 'help'
                " let n .= '[H]' . fnamemodify(bufname(b), ':t:s/.txt$//')
            elseif getbufvar(b, "&buftype") == 'quickfix'
                " let n .= '[Q]'
            elseif getbufvar(b, "&modifiable")
                let n .= fnamemodify(bufname(b), ':t') . ', ' " pathshorten(bufname(b))
            endif
            if getbufvar(b, "&modified")
                let m += 1
            endif
        endfor

        " let n .= fnamemodify(bufname(buflist[tabpagewinnr(i + 1) - 1]), ':t')
        let n = substitute(n, ', $', '', '')

        " add modified label
        if m > 0
            let s .= '+'
            " let s .= '[' . m . '+]'
        endif

        if i + 1 == tabpagenr()
            let s .= ' %#TabLineSel#'
        else
            let s .= ' %#TabLine#'
        endif

        " add buffer names
        if n == ''
            let s.= '[New]'
        else
            let s .= n
        endif

        " switch to no underlining and add final space
        let s .= ' '
    endfor

    let s .= '%#TabLineFill#%T'

    " set the current session name
    " let session_name = util#remove_suffix_recursive(fnamemodify(v:this_session, ':t'))
    if (v:this_session == '')
        let session = 'No session'
    else
        let session = substitute(fnamemodify(v:this_session, ':t'), '\v\.vim', '', '')
    endif
    let s .= '%=%#ColorColumn#' . '[' . session . ']'

    return s
endfunction
