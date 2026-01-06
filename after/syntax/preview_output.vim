" Syntax highlighting para preview output

if exists("b:current_syntax")
  finish
endif

" Heredar de JSON para objetos/arrays
runtime! syntax/json.vim
unlet! b:current_syntax

" === UI del Preview ===
syn match previewCommand /^▶.*$/
syn match previewSeparator /^─\+$/
syn match previewSuccess /^✓.*$/
syn match previewError /^✗.*$/
syn match previewWarning /^⚠.*$/

" === Timestamps (ISO 8601 y formato Go default) ===
syn match previewTimestamp /\d\{4\}-\d\{2\}-\d\{2\}T\d\{2\}:\d\{2\}:\d\{2\}[^"]*/ containedin=jsonString
syn match previewTimestamp /\d\{4\}\/\d\{2\}\/\d\{2\} \d\{2\}:\d\{2\}:\d\{2\}/

" === Log levels ===
" En JSON
syn match previewLogInfo /"INFO"/ containedin=jsonString
syn match previewLogWarn /"WARN"/ containedin=jsonString
syn match previewLogError /"ERROR"/ containedin=jsonString
" En texto plano (slog default, logrus, etc)
syn match previewLogInfo /\<INFO\>/
syn match previewLogWarn /\<WARN\>/
syn match previewLogError /\<ERROR\>/
syn match previewLogDebug /\<DEBUG\>/

" === Texto plano (cuando no es JSON) ===
" Números sueltos en una línea
syn match previewNumber /^\s*-\?\d\+\.\?\d*\s*$/

" key=value (formato slog default, logfmt)
syn match previewLogKey /\<\w\+\ze=/ 
syn match previewLogValue /=\zs"[^"]*"/
syn match previewLogValue /=\zs[^ "]\+/

" === Links a highlight groups de Gruvbox ===
hi def link previewCommand GruvboxBlue
hi def link previewSeparator GruvboxGray
hi def link previewSuccess GruvboxGreen
hi def link previewError GruvboxRed
hi def link previewWarning GruvboxYellow

hi def link previewTimestamp GruvboxAqua
hi def link previewNumber GruvboxOrange

hi def link previewLogInfo GruvboxBlue
hi def link previewLogWarn GruvboxYellow
hi def link previewLogError GruvboxRedBold
hi def link previewLogDebug GruvboxGray

hi def link previewLogKey GruvboxPurple
hi def link previewLogValue GruvboxGreen

let b:current_syntax = "preview_output"
