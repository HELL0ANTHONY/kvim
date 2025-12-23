vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require 'config.globals'
require 'config.options'
require 'config.autocmds'
require 'plugins'

-- Cargar utilidades después de plugins
require 'config.utils.css_convert'
require 'config.utils.json_tpl_format'
require 'config.utils.remove_comments'
require 'config.utils.preview'

-- Filetypes personalizados
vim.filetype.add {
  extension = {
    env = 'dotenv',
    tpl = 'tpl',
  },
  filename = {
    ['.env'] = 'dotenv',
  },
  pattern = {
    ['%.env%.[%w_.-]+'] = 'dotenv',
  },
}

vim.treesitter.language.register('bash', 'dotenv')

-- Cursor
vim.opt.guicursor = {
  'n-v-c:block',
  'i-ci-ve:ver25',
  'r-cr:hor20',
  'o:hor50',
  'sm:block-blinkwait175-blinkoff150-blinkon175',
}

-- Keymaps
local buffers = require 'config.utils.buffers'
vim.keymap.set('n', '<F3>', buffers.close_others, { desc = 'Close other buffers' })
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Code utilities
vim.keymap.set('n', '<leader>cp', '<cmd>Preview<cr>', { desc = 'Code Preview start' })
vim.keymap.set('n', '<leader>cP', '<cmd>PreviewStop<cr>', { desc = 'Code Preview stop' })
vim.keymap.set('n', '<leader>cr', '<cmd>RemoveCommentsInline<cr>', { desc = 'Remove inline comments' })
vim.keymap.set('n', '<leader>cR', '<cmd>RemoveCommentsAll<cr>', { desc = 'Remove all comment lines' })

-- CSS conversions
vim.keymap.set('n', '<leader>cu', '<cmd>CssToggle<cr>', { desc = 'CSS toggle px/rem' })
vim.keymap.set('n', '<leader>cv', '<cmd>CssToggleVw<cr>', { desc = 'CSS toggle px/vw' })
vim.keymap.set('n', '<leader>cc', '<cmd>ColorToggle<cr>', { desc = 'Color cycle format' })
vim.keymap.set('n', '<leader>ch', '<cmd>ColorToHex<cr>', { desc = 'Color to hex' })

-- JSON/TPL
vim.keymap.set('n', '<leader>fj', '<cmd>JsonTplFormat<cr>', { desc = 'Format JSON/TPL' })
vim.keymap.set('n', '<leader>fJ', '<cmd>JsonTplValidate<cr>', { desc = 'Validate JSON/TPL' })

-- Quickfix/Location list
vim.keymap.set('n', '<leader>xq', lk.toggle_qf, { desc = 'Toggle quickfix' })
vim.keymap.set('n', '<leader>xl', lk.toggle_loc, { desc = 'Toggle loclist' })
