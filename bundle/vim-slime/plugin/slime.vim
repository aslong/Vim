
if exists('g:loaded_slime') || &cp || v:version < 700
  finish
endif
let g:loaded_slime = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if !exists("g:slime_target")
  let g:slime_target = "screen"
end

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Screen
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! s:ScreenSend(config, text)
  let escaped_text = substitute(shellescape(a:text), "\\\\\\n", "\n", "g")
  call system("screen -S " . shellescape(a:config["sessionname"]) . " -p " . shellescape(a:config["windowname"]) . " -X stuff " . escaped_text)
endfunction

function! s:ScreenSessionNames(A,L,P)
  return system("screen -ls | awk '/Attached/ {print $1}'")
endfunction

function! s:ScreenConfig() abort
  if !exists("b:slime_config")
    let b:slime_config = {"sessionname": "", "windowname": "0"}
  end

  let b:slime_config["sessionname"] = input("screen session name: ", b:slime_config["sessionname"], "custom,<SNR>" . s:SID() . "_ScreenSessionNames")
  let b:slime_config["windowname"]  = input("screen window name: ",  b:slime_config["windowname"])
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Tmux
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! s:TmuxSend(config, text)
  call system("tmux -L " . shellescape(a:config["socket_name"]) . " load-buffer -", a:text)
  call system("tmux -L " . shellescape(a:config["socket_name"]) . " paste-buffer -t " . shellescape(a:config["target_pane"]))
endfunction

function! s:TmuxPaneNames(A,L,P)
  let format = '#{pane_id} #{session_name}:#{window_index}.#{pane_index} #{window_name}#{?window_active, (active),}'
  return system("tmux -L " . shellescape(b:slime_config['socket_name']) . " list-panes -a -F " . shellescape(format))
endfunction

function! s:TmuxConfig() abort
  if !exists("b:slime_config")
    let b:slime_config = {"socket_name": "default", "target_pane": ":"}
  end

  let b:slime_config["socket_name"] = input("tmux socket name: ", b:slime_config["socket_name"])
  let b:slime_config["target_pane"] = input("tmux target pane: ", b:slime_config["target_pane"], "custom,<SNR>" . s:SID() . "_TmuxPaneNames")
  if b:slime_config["target_pane"] =~ '\s\+'
    let b:slime_config["target_pane"] = split(b:slime_config["target_pane"])[0]
  endif
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Helpers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! s:SID()
  return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_SID$')
endfun

function! s:_EscapeText(text)
  let transformed_text = a:text

  if exists("&filetype")
    let custom_escape = "_EscapeText_" . &filetype
    if exists("*" . custom_escape)
        let transformed_text = call(custom_escape, [a:text])
    end
  end

  return transformed_text
endfunction

function! s:SlimeSendOp(type, ...) abort
  if !exists("b:slime_config")
    call s:SlimeDispatch('Config')
  end

  let sel_save = &selection
  let &selection = "inclusive"
  let rv = getreg('"')
  let rt = getregtype('"')

  if a:0  " Invoked from Visual mode, use '< and '> marks.
    silent exe "normal! `<" . a:type . '`>y'
  elseif a:type == 'line'
    silent exe "normal! '[V']y"
  elseif a:type == 'block'
    silent exe "normal! `[\<C-V>`]\y"
  else
    silent exe "normal! `[v`]y"
  endif

  call setreg('"', @", 'V')
  call s:SlimeSend(@")

  let &selection = sel_save
  call setreg('"', rv, rt)
endfunction

function! s:SlimeSendRange() range abort
  if !exists("b:slime_config")
    call s:SlimeDispatch('Config')
  end

  let rv = getreg('"')
  let rt = getregtype('"')
  sil exe a:firstline . ',' . a:lastline . 'yank'
  call s:SlimeSend(@")
  call setreg('"', rv, rt)
endfunction

function! s:SlimeSendLines(count) abort
  if !exists("b:slime_config")
    call s:SlimeDispatch('Config')
  end

  let rv = getreg('"')
  let rt = getregtype('"')
  exe "norm! " . a:count . "yy"
  call s:SlimeSend(@")
  call setreg('"', rv, rt)
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Public interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! s:SlimeSend(text)
  if !exists("b:slime_config")
    let msg = "Slime is not configured for this buffer. Please run :SlimeConfig"
    echohl ErrorMsg
    echoerr msg
    echohl None
    let v:errmsg = 'slime: ' . msg
    throw v:errmsg
  end
  let transformed_text = s:_EscapeText(a:text)
  call s:SlimeDispatch('Send', b:slime_config, transformed_text)
endfunction

function! s:SlimeConfig() abort
  call inputsave()
  call s:SlimeDispatch('Config')
  call inputrestore()
endfunction

" delegation
function! s:SlimeDispatch(name, ...)
  let target = substitute(tolower(g:slime_target), '\(.\)', '\u\1', '') " Capitalize
  return call("s:" . target . a:name, a:000)
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Setup key bindings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

command -bar -nargs=0 SlimeConfig call s:SlimeConfig()
command -range -bar -nargs=0 SlimeSend <line1>,<line2>call s:SlimeSendRange()

noremap <SID>Operator :<c-u>set opfunc=<SID>SlimeSendOp<cr>g@

noremap <unique> <script> <silent> <Plug>SlimeRegionSend :<c-u>call <SID>SlimeSendOp(visualmode(), 1)<cr>
noremap <unique> <script> <silent> <Plug>SlimeLineSend :<c-u>call <SID>SlimeSendLines(v:count1)<cr>
noremap <unique> <script> <silent> <Plug>SlimeMotionSend <SID>Operator
noremap <unique> <script> <silent> <Plug>SlimeParagraphSend <SID>Operatorip
noremap <unique> <script> <silent> <Plug>SlimeConfig :<c-u>SlimeConfig<cr>

if !exists("g:slime_no_mappings") || !g:slime_no_mappings
  if !hasmapto('<Plug>SlimeRegionSend', 'x')
    xmap <c-c><c-c> <Plug>SlimeRegionSend
  endif

  if !hasmapto('<Plug>SlimeParagraphSend', 'n')
    nmap <c-c><c-c> <Plug>SlimeParagraphSend
  endif

  if !hasmapto('<Plug>SlimeConfig', 'n')
    nmap <c-c>v <Plug>SlimeConfig
  endif
endif

