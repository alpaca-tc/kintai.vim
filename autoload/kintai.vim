function! s:build_template(content)
  let temp = tempname()
  call writefile(split(a:content, '\n'), temp)

  return temp
endfunction

function! kintai#get_configuration(key) "{{{
  if exists('*g:kintai#configuration.' . a:key)
    return g:kintai#configuration[a:key]()
  elseif has_key(g:kintai#configuration, a:key)
    return g:kintai#configuration[a:key]
  endif
endfunction"}}}

function! kintai#send_request() "{{{
  let url = kintai#get_configuration('url')
  %yank
  execute 'OpenBrowser' url
endfunction"}}}

function! kintai#open_template(content) "{{{
  let template = s:build_template(a:content)
  new `=template`
  call s:set_variables()

  augroup AlpacaTemplateConfiguration
    autocmd BufWriteCmd <buffer> call kintai#get_configuration('send_request')
  augroup END
  doautocmd User BuildKintaiPost
endfunction"}}}

function! s:set_variables() "{{{
  setlocal filetype=text
  setlocal syntax=markdown
  setlocal bufhidden=hide
  setlocal buftype=acwrite
  setlocal nolist
  setlocal nobuflisted
  if has('cursorbind')
    setlocal nocursorbind
  endif
  setlocal noscrollbind
  setlocal noswapfile
  setlocal nospell
  setlocal noreadonly
  setlocal nofoldenable
  setlocal nomodeline
  setlocal foldcolumn=0
  setlocal iskeyword+=-,+,\\,!,~
  setlocal matchpairs-=<:>

  if has('conceal')
    setlocal conceallevel=3
    setlocal concealcursor=n
  endif
  if exists('+cursorcolumn')
    setlocal nocursorcolumn
  endif
  if exists('+colorcolumn')
    setlocal colorcolumn=0
  endif
  if exists('+relativenumber')
    setlocal norelativenumber
  endif
endfunction"}}}

augroup AlpacaKintai
  autocmd!
  autocmd User BuildKintaiPost call s:set_variables()
augroup END
