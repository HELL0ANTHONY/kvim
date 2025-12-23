" Heredar de JSON
runtime! syntax/json.vim

" Resaltar interpolaciones Terraform ${...}
syn match terraformInterpolation /\${[^}]*}/ containedin=jsonString
hi link terraformInterpolation Special
