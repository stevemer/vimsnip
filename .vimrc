function! s:StringEncodeURL(text)
  let retVal = ""
  for cSymbol in split(a:text, '\zs')
    if cSymbol == '"'
      let retVal .= '\"'
    elseif cSymbol == "'"
      let retVal .= '\u0027'
    elseif cSymbol == '\'
      let retVal .= '\\'
    else
      let retVal .= cSymbol
    endif
  endfor
  return retVal
endfunction
function! Snippet() range
""""""""""""""""""""""""""""""""""""
"" USERNAME FOR STASH              "
  let USERNAME = 'username'        " change this
""""""""""""""""""""""""""""""""""""
  if (!exists('g:nickID'))
    let g:nickID = inputdialog("Enter a title for this Snippet: ", "") 
    let PWD = inputsecret("Password: ", "") 
  endif
  let g:check = 0 
  let LINES = getline(a:firstline, a:lastline)
  let DATA = ''
  for line in LINES
    let DATA .= s:StringEncodeURL(line).'\n'
  endfor
  let FILENAME = expand("%:t")
  let ACTION = "curl -X POST"
  let AUTHENTICATION = "-u ".USERNAME.":".PWD
  let CONTENT = '-H "Content-Type:application/json" -d'
  let JSON = "{ \"name\" : \"".g:nickID."\", \"files\" : [{ \"name\" : \"".FILENAME."\", \"content\" : \"".DATA."\" }] }"
  let URL = "https://stash.my_server.com/rest/snippets/1.0/snippets"
  let REQUEST = ACTION." ".AUTHENTICATION." ".CONTENT." '".JSON."' ".URL
  let output = split(split(system(REQUEST), '\n')[3], ',')[0][9:-2]
  let snipsite = "https://stash.my_server.com/plugins/servlet/snippets/"
  let location = "Your paste has been uploaded to ".snipsite.output
  let @* = snipsite.output
  redraw
  echomsg location
  unlet g:nickID
endfunction

" Command to call the function
com! -range=% -nargs=0 Snippet :<line1>,<line2>call Snippet()
