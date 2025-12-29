local M = {}

local comment_chars = {
  go = "//",
  javascript = "//",
  javascriptreact = "//",
  typescript = "//",
  typescriptreact = "//",
  lua = "%-%-",
  python = "#",
  yaml = "#",
  bash = "#",
  sh = "#",
}

-- Remueve comentarios inline (al final de líneas con código)
-- No elimina líneas que son solo comentarios
M.remove_inline = function()
  local ft = vim.bo.filetype
  local cc = comment_chars[ft]

  if not cc then
    vim.notify("Filetype no soportado: " .. ft, vim.log.levels.WARN)
    return
  end

  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local changed = 0

  for i, line in ipairs(lines) do
    -- Busca comentario que NO esté al inicio (tiene código antes)
    -- Ignora comentarios dentro de strings (simplificado)
    local code_before = line:match("^(.-)%s*" .. cc)

    if code_before and code_before:match("%S") then
      -- Hay código antes del comentario
      lines[i] = code_before:gsub("%s+$", "") -- Trim trailing spaces
      changed = changed + 1
    end
  end

  if changed > 0 then
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
    vim.notify(
      ("Eliminados %d comentarios inline"):format(changed),
      vim.log.levels.INFO
    )
  else
    vim.notify("No se encontraron comentarios inline", vim.log.levels.INFO)
  end
end

-- Remueve TODAS las líneas que son solo comentarios
M.remove_all = function()
  local ft = vim.bo.filetype
  local cc = comment_chars[ft]

  if not cc then
    vim.notify("Filetype no soportado: " .. ft, vim.log.levels.WARN)
    return
  end

  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local new_lines = {}
  local removed = 0

  for _, line in ipairs(lines) do
    local trimmed = line:match("^%s*(.-)%s*$")
    -- Si la línea NO empieza con comentario (o está vacía), la mantenemos
    if trimmed == "" or not trimmed:match("^" .. cc) then
      table.insert(new_lines, line)
    else
      removed = removed + 1
    end
  end

  if removed > 0 then
    vim.api.nvim_buf_set_lines(0, 0, -1, false, new_lines)
    vim.notify(
      ("Eliminadas %d líneas de comentarios"):format(removed),
      vim.log.levels.INFO
    )
  else
    vim.notify("No se encontraron líneas de comentarios", vim.log.levels.INFO)
  end
end

-- User commands
vim.api.nvim_create_user_command("RemoveCommentsInline", M.remove_inline, {
  desc = "Remueve comentarios al final de líneas con código",
})

vim.api.nvim_create_user_command("RemoveCommentsAll", M.remove_all, {
  desc = "Remueve todas las líneas que son solo comentarios",
})

return M
