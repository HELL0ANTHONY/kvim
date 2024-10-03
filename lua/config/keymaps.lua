local fn = require 'config.custom_functions'

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<leader>;c', function()
  fn.remove_comments()
end, { desc = 'Remove inline comments' })

-- ==================================== LSP ====================================
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('n', '<C-k>', '<cmd>lua vim.diagnostic.open_float()<CR>', { desc = 'Float error' })

-- ==================================== BUFFERS ==============================
-- Close all buffers except one
function CloseBuffers()
  local cursor_pos = vim.fn.getpos '.'
  vim.cmd 'wa | %bd | e# | bd!#'
  vim.fn.setpos('.', cursor_pos)
end

vim.keymap.set('n', '<leader>;Q', '<cmd>lua CloseBuffers()<CR>', { desc = 'Close all buffers' })

-- ==================================== TERMINAL ==============================
-- https://stackoverflow.com/questions/1236563/how-do-i-run-a-terminal-inside-of-vim

-- Define the function globally
function _G.OpenTerminal()
  vim.cmd 'split term://zsh'
  vim.cmd 'resize 12'
end
vim.api.nvim_set_keymap('n', '<leader>;T', ':lua OpenTerminal()<CR>', { noremap = true, silent = true, desc = 'Open zsh Terminal' })

-- ==================================== OPEN NETRW ===========================
function _G.toggle_netrw()
  for _, win in pairs(vim.api.nvim_list_wins()) do
    local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(win))
    if bufname:match 'NetrwTree' then
      vim.api.nvim_win_close(win, true)
      return
    end
  end
  vim.cmd 'Lexplore %:p:h'
end

vim.api.nvim_set_keymap('n', '<leader>e', ':lua toggle_netrw()<CR>', { noremap = true, silent = true, desc = 'Open Netrw explore' })
