_G.lk = {}

-- Debug: inspeccionar cualquier valor
-- Uso: :lua P(vim.opt.rtp)
P = function(v)
  print(vim.inspect(v))
  return v
end

-- Bordes consistentes para todo
lk.border = {
  rounded = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
  single = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
  float = "rounded", -- Para usar en vim.lsp.buf.hover, etc.
}

-- Toggle quickfix list
lk.toggle_qf = function()
  local qf_open = false
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "qf" then
      qf_open = true
      break
    end
  end

  if qf_open then
    vim.cmd.cclose()
  elseif #vim.fn.getqflist() > 0 then
    vim.cmd.copen()
  else
    vim.notify("Quickfix list is empty", vim.log.levels.INFO)
  end
end

-- Toggle location list
lk.toggle_loc = function()
  local loc_open = false
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if
      vim.fn.getloclist(vim.api.nvim_win_get_number(win), { filewinid = 0 }).filewinid
      > 0
    then
      loc_open = true
      break
    end
  end

  if loc_open then
    vim.cmd.lclose()
  elseif #vim.fn.getloclist(0) > 0 then
    vim.cmd.lopen()
  else
    vim.notify("Location list is empty", vim.log.levels.INFO)
  end
end

-- Obtener severidad más alta de diagnósticos del buffer actual
lk.get_highest_diagnostic_severity = function()
  local dominated = {
    vim.diagnostic.severity.ERROR,
    vim.diagnostic.severity.WARN,
    vim.diagnostic.severity.INFO,
    vim.diagnostic.severity.HINT,
  }
  for _, level in ipairs(dominated) do
    local diags = vim.diagnostic.get(0, { severity = { min = level } })
    if #diags > 0 then
      return level, diags
    end
  end
  return nil, {}
end
