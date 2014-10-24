function! kintai#snail#available()
  return executable('snail_parser')
endfunction

function! kintai#snail#build_template(path)
  let result = system('snail_parser --formatter Vim --path ' . a:path)
  sandbox let rows = eval(result)

  let tasks = {
        \ 'Completed' : [],
        \ 'Overdue' : [],
        \ 'New': []
        \ }

  for row in rows
    call add(tasks[row['status']], s:row2line(row))
  endfor

  if s:at_morning()
    return  "■本日の予定\n" .
          \ "(新規)\n" .
          \ join(tasks['New'], "\n") .
          \ "\n\n(続き)\n" .
          \ join(tasks['Overdue'], "\n")
  else
    return  "■業務内容\n" .
          \ "(完了)\n" . join(tasks['Completed'], "\n") .
          \ "\n\n(やり残していること:継続)\n" . join(tasks['Overdue'], "\n") .
          \ "\n\n(明日やること:新規)\n" . join(tasks['New'], "\n") .
          \ "\n\n■一言\nお疲れ様です"
  end
endfunction

function! s:row2line(row)
  let time = a:row['time_spent'][0:4]
  return '- (' . time . ') ' . a:row['title']
endfunction

function! s:at_morning()
  let hours = str2nr(strftime("%H"))
  if hours < 5 && hours < 12
    return 1
  else
    return 0
  endif
endfunction
