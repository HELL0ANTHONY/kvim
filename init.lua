vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Cargar utilidades antes de opciones y plugins
require 'config.utils.css_convert'
require 'config.utils.remove_comments'
require 'config.utils.preview'

require 'config.options'
require 'config.autocmds'
require 'plugins'

-- Filetypes personalizados
vim.filetype.add {
  extension = { env = 'dotenv', tpl = 'smarty' },
  filename = { ['.env'] = 'dotenv', ['index.tpl'] = 'smarty' },
  pattern = { ['%.env%.[%w_.-]+'] = 'dotenv', ['%.tpl$'] = 'smarty' },
}
vim.treesitter.language.register('bash', 'dotenv')
vim.treesitter.language.register('html', 'smarty')

-- Cursor
vim.opt.guicursor = {
  'n-v-c:block',
  'i-ci-ve:ver25',
  'r-cr:hor20',
  'o:hor50',
  'sm:block-blinkwait175-blinkoff150-blinkon175',
}

local buffers = require 'config.utils.buffers'
vim.keymap.set('n', '<F3>', buffers.close_others, { desc = 'Close other buffers' })
vim.keymap.set('n', '<leader>cp', '<cmd>Preview<cr>', { desc = 'Code Preview start' })
vim.keymap.set('n', '<leader>cP', '<cmd>PreviewStop<cr>', { desc = 'Code Preview stop' })
vim.keymap.set('n', '<leader>cr', '<cmd>RemoveCommentsInline<cr>', { desc = 'Remove inline comments' })
vim.keymap.set('n', '<leader>cR', '<cmd>RemoveCommentsAll<cr>', { desc = 'Remove all comment lines' })

-- Unidades (bajo cursor)
vim.keymap.set('n', '<leader>cu', '<cmd>CssToggle<cr>', { desc = 'CSS toggle px/rem' })
vim.keymap.set('n', '<leader>cv', '<cmd>CssToggleVw<cr>', { desc = 'CSS toggle px/vw' })

-- Colores (bajo cursor)
vim.keymap.set('n', '<leader>cc', '<cmd>ColorToggle<cr>', { desc = 'Color cycle format' })
vim.keymap.set('n', '<leader>ch', '<cmd>ColorToHex<cr>', { desc = 'Color to hex' })

-- Batch
-- vim.keymap.set('n', '<leader>cR', '<cmd>CssAllPxToRem<cr>', { desc = 'All px→rem' })
