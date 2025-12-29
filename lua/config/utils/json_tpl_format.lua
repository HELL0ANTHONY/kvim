local M = {}

-- instalar brew install jq
-- Formatea JSON que contiene interpolaciones ${...} de Terraform
-- Estrategia: reemplazar ${...} temporalmente, formatear, restaurar

M.format = function()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local content = table.concat(lines, "\n")

  -- Guardar interpolaciones ${...} con placeholders seguros
  local placeholders = {}
  local counter = 0

  local sanitized = content:gsub("%${([^}]+)}", function(inner)
    counter = counter + 1
    local key = string.format("TFPH%04d", counter)
    placeholders[key] = "${" .. inner .. "}"
    return key
  end)

  -- Escribir a archivo temporal
  local tmpfile = os.tmpname()
  local f = io.open(tmpfile, "w")
  if not f then
    vim.notify("Error creando archivo temporal", vim.log.levels.ERROR)
    return
  end
  f:write(sanitized)
  f:close()

  -- Formatear con jq
  local result = vim.fn.system("jq --indent 2 . " .. tmpfile .. " 2>&1")
  os.remove(tmpfile)

  if vim.v.shell_error ~= 0 then
    vim.notify("JSON inválido:\n" .. result, vim.log.levels.ERROR)
    return
  end

  -- Restaurar interpolaciones
  for key, original in pairs(placeholders) do
    result = result:gsub(key, original)
  end

  -- Aplicar al buffer
  local new_lines = vim.split(result:gsub("\n$", ""), "\n")
  vim.api.nvim_buf_set_lines(0, 0, -1, false, new_lines)
  vim.notify("JSON formateado ✓", vim.log.levels.INFO)
end

M.validate = function()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local content = table.concat(lines, "\n")

  -- Reemplazar interpolaciones con strings válidos
  local sanitized = content:gsub("%${[^}]+}", "placeholder")

  local tmpfile = os.tmpname()
  local f = io.open(tmpfile, "w")
  f:write(sanitized)
  f:close()

  local result = vim.fn.system("jq . " .. tmpfile .. " 2>&1")
  os.remove(tmpfile)

  if vim.v.shell_error == 0 then
    vim.notify("JSON válido ✓", vim.log.levels.INFO)
  else
    vim.notify("JSON inválido:\n" .. result, vim.log.levels.ERROR)
  end
end

vim.api.nvim_create_user_command("JsonTplFormat", M.format, {
  desc = "Formatea JSON con interpolaciones Terraform",
})

vim.api.nvim_create_user_command("JsonTplValidate", M.validate, {
  desc = "Valida JSON con interpolaciones Terraform",
})

return M
