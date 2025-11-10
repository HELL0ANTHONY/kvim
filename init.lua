vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require 'config.options' -- siempre debe ir arriba de todo.
require 'config.autocmds'
require 'config.custom_functions'
require 'config.globals'
-- require 'config.keymaps'
require 'plugins'

-- ======================== Configuraciones extras (START) =====================
-- Agrega estilos a los archivos .env u otros archivos de configuracion.
vim.filetype.add {
  extension = {
    env = 'dotenv',
    tpl = 'smarty',
  },
  filename = {
    ['.env'] = 'dotenv',
    ['index.tpl'] = 'smarty',
  },
  pattern = {
    ['%.env%.[%w_.-]+'] = 'dotenv',
    ['%.tpl$'] = 'smarty',
  },
}
vim.treesitter.language.register('bash', 'dotenv')
vim.treesitter.language.register('html', 'smarty')

-- Estilos del cursor.
vim.opt.guicursor = {
  'n-v-c:block', -- Normal, Visual, Command = bloque
  'i-ci-ve:ver25', -- Insert, Insert-completion, Visual-Select = barra vertical
  'r-cr:hor20', -- Replace = cursor subrayado
  'o:hor50', -- Operator-pending = subrayado más grueso
  'sm:block-blinkwait175-blinkoff150-blinkon175', -- visual feedback
}

-- ======================== keymaps (START) ==================================
local buffers = require 'config.utils.buffers'
vim.keymap.set('n', '<leader>x', buffers.close_others, { desc = ' Close other buffers' })

-- Limpia las busquedas.
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

function _G.OpenTerminal()
  local os_name = vim.loop.os_uname().sysname
  if os_name == 'Windows_NT' then
    vim.cmd 'split term://pwsh'
  else
    vim.cmd 'split term://zsh'
  end
  vim.cmd 'resize 12'
end
vim.keymap.set('n', '<leader>ot', OpenTerminal, { silent = true, desc = '[o]pen terminal' })
