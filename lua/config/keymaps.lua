local fn = require 'config.custom_functions'

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set('n', '<leader>;r', function()
  fn.remove_comments()
end, { desc = '[r]emove inline comments' })

-- ==================================== MARKS ==============================
-- :RecallMark - Mark the current line.
-- :RecallUnmark - Unmark the current line.
-- :RecallToggle - Mark or unmark the current line.
-- :RecallNext/:RecallPrevious - Navigate through marks linearly, respecting the sequence A-Z and wrapping accordingly.
-- :RecallClear - Clear all global marks.
vim.keymap.set('n', '<leader>M', '<CMD>RecallMark<CR>', { desc = '󰃅 Add a new [M]ark' })
vim.keymap.set('n', '<leader>`', '<CMD>RecallClear<CR>', { desc = '󰃆 Clear all Mark' })
vim.keymap.set('n', '<leader>m`', '<CMD>Telescope recall<CR>', { desc = '󰸕 Show [m]arks' })

-- ==================================== SIDEBAR ==============================
vim.keymap.set('n', '-', '<CMD>Oil --float<CR>', { desc = ' Open parent directory' })

-- ==================================== BUFFERS ==============================
-- Close all buffers except one
function CloseBuffers()
  local cursor_pos = vim.fn.getpos '.'
  vim.cmd 'wa | %bd | e# | bd!#'
  vim.fn.setpos('.', cursor_pos)
end

vim.keymap.set('n', '<leader>;C', '<cmd>lua CloseBuffers()<CR>', { desc = ' [C]lose all buffers' })

-- ==================================== TERMINAL ==============================
-- https://stackoverflow.com/questions/1236563/how-do-i-run-a-terminal-inside-of-vim

-- Define the function globally
function _G.OpenTerminal()
  vim.cmd 'split term://zsh'
  vim.cmd 'resize 12'
end
vim.api.nvim_set_keymap('n', '<leader>ot', ':lua OpenTerminal()<CR>', { noremap = true, silent = true, desc = ' [o]pen zsh [t]erminal' })

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

vim.api.nvim_set_keymap('n', '<leader>te', ':lua toggle_netrw()<CR><C-w>r', { noremap = true, silent = true, desc = '[t]oggle Netrw [e]xplore' })
