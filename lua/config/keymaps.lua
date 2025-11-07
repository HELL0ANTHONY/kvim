-- Esc para limpiar búsqueda
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- remove inline comments
-- local fn = require 'config.custom_functions'
-- vim.keymap.set('n', '<leader>;r', fn.remove_comments, { desc = '[r]emove inline comments' })

-- Recall
-- vim.keymap.set('n', '<leader>M', '<CMD>RecallMark<CR>', { desc = '󰃅 Add a new [M]ark' })
-- vim.keymap.set('n', '<leader>`', '<CMD>RecallUnmark<CR>', { desc = '󰃆 Clear current Mark' })
-- vim.keymap.set('n', '<leader>m`', '<CMD>Telescope recall<CR>', { desc = '󰸕 Show [m]arks' })

-- Close buffers
local function CloseBuffers()
  local cursor_pos = vim.fn.getpos '.'
  vim.cmd 'wa | %bd | e# | bd!#'
  vim.fn.setpos('.', cursor_pos)
end

vim.keymap.set('n', '<leader>;C', CloseBuffers, { desc = ' [C]lose all buffers' })

-- Terminal
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
