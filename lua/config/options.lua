-- https://learnxinyminutes.com/docs/lua/
-- https://evantravers.com/articles/2024/09/17/making-my-nvim-act-more-like-helix-with-mini-nvim/

-- See `:help vim.opt`

-- Cursor configuration
vim.cmd [[
  let &t_SI = "\e[5 q"
  let &t_SR = "\e[3 q"
  let &t_EI = "\e[1 q"
]]

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set termguicolors to enable highlight groups (default: false)
vim.opt.termguicolors = true

-- Muestra opciones de búsqueda en una barra de menú.
vim.opt.wildmenu = true

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = false

-- Make line numbers default (default: false)
vim.opt.number = true

-- Set relative numbered lines (default: false)
vim.opt.relativenumber = false

-- Display lines as one long line (default: true)
vim.opt.wrap = false

-- Realiza saltos de línea de manera inteligente.
vim.opt.linebreak = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = ''

-- Pop up menu height (default: 0)
vim.opt.pumheight = 10

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Force all horizontal splits to go below current window (default: false)
vim.o.splitbelow = true

-- Force all vertical splits to go to the right of current window (default: false)
vim.o.splitright = true

-- Muestra una columna vertical en la posición 80 para ayudar a seguir las guías de estilo.
vim.opt.colorcolumn = '80'

-- Establece la cantidad de espacios al hacer indentación.
vim.opt.shiftwidth = 2

-- Habilita la indentación automática.
vim.opt.smartindent = true

-- Configura la cantidad de espacios al usar la tecla Tab.
vim.opt.softtabstop = 2

-- Configura la cantidad de espacios por tabulación.
vim.opt.tabstop = 2

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
-- Ctrl + V seguido de u2022 (unicode)
vim.opt.listchars = { tab = '⇥ ', trail = '+', eol = '﬋', space = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- More space in the Neovim command line for displaying messages (default: 1)
vim.opt.cmdheight = 1

-- Netrw config
-- https://vonheikemen.github.io/devlog/tools/using-netrw-vim-builtin-file-explorer/

-- Desactiva el banner de Netrw
vim.g.netrw_banner = 0

-- Estilo de lista de Netrw (3 es el árbol de directorios)
vim.g.netrw_liststyle = 3

-- Configura que Netrw abra la ventana en un nuevo split en la derecha
vim.g.netrw_browse_split = 4

-- Establece el tamaño de la ventana de Netrw (30% del espacio disponible)
vim.g.netrw_winsize = 30

vim.g.netrw_keepdir = 0

vim.cmd [[
  function! OpenToRight()
    :normal v
    let g:path=expand('%:p')
    execute 'q!'
    execute 'rightbelow vnew' g:path
    :normal <C-w>l
  endfunction
  
  function! OpenBelow()
    :normal v
    let g:path=expand('%:p')
    execute 'q!'
    execute 'rightbelow new' g:path
    :normal <C-w>l
  endfunction
  
  function! OpenTab()
    :normal v
    let g:path=expand('%:p')
    execute 'q!'
    execute 'tabedit' g:path
    :normal <C-w>l
  endfunction
  
  function! NetrwMappings()
    " Hack fix to make ctrl-l work properly
    noremap <buffer> <A-l> <C-w>l
    noremap <buffer> <C-l> <C-w>l
    noremap <silent> <A-;> :call ToggleNetrw()<CR>
    noremap <buffer> V :call OpenToRight()<cr>
    noremap <buffer> H :call OpenBelow()<cr>
    noremap <buffer> T :call OpenTab()<cr>
  endfunction
  
  augroup netrw_mappings
    autocmd!
    autocmd filetype netrw call NetrwMappings()
  augroup END
  
  " Allow for netrw to be toggled
  function! ToggleNetrw()
    if g:NetrwIsOpen
      let i = bufnr("$")
      while (i >= 1)
        if (getbufvar(i, "&filetype") == "netrw")
          silent exe "bwipeout " . i
        endif
        let i-=1
      endwhile
      let g:NetrwIsOpen=0
    else
      let g:NetrwIsOpen=1
      silent Lexplore
    endif
  endfunction
  
  " Check before opening buffer on any file
  function! NetrwOnBufferOpen()
    if exists('b:noNetrw')
      return
    endif
    call ToggleNetrw()
  endfun
  
  " Close Netrw if it's the only buffer open
  autocmd WinEnter * if winnr('$') == 1 && getbufvar(winbufnr(winnr()), "&filetype") == "netrw" || &buftype == 'quickfix' |q|endif
  
  " Make netrw act like a project Draw
  augroup ProjectDrawer
    autocmd!
    " Don't open Netrw
    autocmd VimEnter ~/.config/joplin/tmp/*,/tmp/calcurse*,~/.calcurse/notes/*,~/vimwiki/*,*/.git/COMMIT_EDITMSG let b:noNetrw=1
    autocmd VimEnter * :call NetrwOnBufferOpen()
  augroup END

  " Show numbers
  set updatetime=100
  autocmd CursorHold * if (&filetype == 'netrw' && &number == 0) | set number relativenumber nu | endif
  
  " To open Netrw from the beginning change the value to 0 
  let g:NetrwIsOpen=1
  nnoremap <leader>r :call OpenToRight()<CR>
]]
