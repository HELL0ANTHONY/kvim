--- Utility module to manage and close Neovim buffers.
--- Provides functions to close other buffers while preserving the current one.
--- @module close_others
local M = {}

--- @param buf integer Buffer handle
--- @return boolean
local function is_listed(buf)
  return vim.bo[buf].buflisted
end

--- Closes all listed buffers except the current one.
--- Automatically saves modified buffers before closing them.
--- It preserves the cursor position and reopens the current buffer if needed.
function M.close_others()
  local cur = vim.api.nvim_get_current_buf()
  local pos = vim.fn.getpos(".")

  -- Save all modified and valid buffers
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if
      vim.bo[b].modified
      and vim.api.nvim_buf_get_name(b) ~= ""
      and vim.bo[b].buftype == "" -- avoid terminal/quickfix/nofile buffers
      and vim.bo[b].modifiable
    then
      pcall(function()
        vim.api.nvim_buf_call(b, function()
          vim.cmd("write")
        end)
      end)
    end
  end

  -- Close all other listed buffers
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if b ~= cur and is_listed(b) then
      pcall(vim.api.nvim_buf_delete, b, { force = true })
    end
  end

  -- Restore current buffer and cursor position
  if vim.api.nvim_buf_is_loaded(cur) then
    vim.api.nvim_set_current_buf(cur)
  end
  vim.fn.setpos(".", pos)
end

--- Quickly closes all buffers and opens a new empty one.
--- This method is faster but does not attempt to save modified buffers.
--- It also preserves the cursor position.
function M.close_others_fast()
  local pos = vim.fn.getpos(".")
  vim.cmd("silent! %bdelete")
  vim.cmd("enew")
  vim.fn.setpos(".", pos)
end

return M
