if exists('g:loaded_kintai')
  finish
endif
let g:loaded_kintai = 1

let s:save_cpo = &cpo
set cpo&vim

if !exists('g:kintai#configuration')
  let g:kintai#configuration = {
        \ 'url' : 'http://example.com',
        \ 'body' : "■サンプル文章\n",
        \ }
endif

if !has_key(g:kintai#configuration, 'send_request')
  function! g:kintai#configuration.send_request()
    call kintai#send_request()
  endfunction
endif

command! CreateKintai call kintai#open_template()

let &cpo = s:save_cpo
unlet s:save_cpo
