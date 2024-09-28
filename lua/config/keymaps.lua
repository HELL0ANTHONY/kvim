vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- ==================================== LSP ====================================
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', { desc = 'Float error' })

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
  vim.cmd 'resize 8'
end
vim.api.nvim_set_keymap('n', '<leader>;T', ':lua OpenTerminal()<CR>', { noremap = true, silent = true, desc = 'Open zsh Terminal' })
