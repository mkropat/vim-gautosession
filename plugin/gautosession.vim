if exists('g:loaded_gautosession') || argc()
  finish
else
  let g:loaded_gautosession = 'yes'
endif

if has('gui')
  function! s:is_enabled()
    return !exists('g:gautosession_gui') || g:gautosession_gui
  endfunction
else
  function! s:is_enabled()
    return exists('g:gautosession_tui') && g:gautosession_tui
  endfunction
endif

if has('win32')
  let s:session_path = $HOME . '\vimfiles\gauto.session'
else
  let s:session_path = $HOME . '/.vim/gauto.session'
endif

function! s:load_session()
  if s:is_enabled() && filereadable(s:session_path)
    execute 'source' s:session_path
  endif
endfunction

function! s:save_session()
  if v:dying || !s:is_enabled()
    return
  endif

  let original_sessionoptions = &sessionoptions
  try
    set sessionoptions-=blank sessionoptions-=options sessionoptions+=tabpages
    execute 'mksession!' s:session_path
  finally
    let &sessionoptions = original_sessionoptions
  endtry
endfunction

autocmd VimEnter * nested call s:load_session()
autocmd VimLeavePre * call s:save_session()
