local M = {}

function M.current_file_path()
  local path = vim.api.nvim_buf_get_name(0)
  if path == "" then
    return nil
  end

  return vim.fn.fnamemodify(path, ":.")
end

function M.copy_current_file_path(opts)
  opts = opts or {}

  local path = M.current_file_path()
  if not path then
    if opts.notify ~= false then
      vim.notify("Current buffer has no file path", vim.log.levels.WARN)
    end
    return nil
  end

  vim.fn.setreg('"', path)
  vim.fn.setreg("+", path)

  if opts.notify ~= false then
    vim.notify("Copied path: " .. path)
  end

  return path
end

return M
