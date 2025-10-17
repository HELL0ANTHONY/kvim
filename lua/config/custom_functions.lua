local M = {}

-- Comandos por defecto por filetype
local DEFAULT_COMMANDS = {
  javascript = { 'node', '%' },
  javascriptreact = { 'node', '%' }, -- requiere transpilar si usas JSX real
  typescript = { 'ts-node', '%' },
  typescriptreact = { 'ts-node', '%' }, -- requiere ts-node y tsconfig
  go = { 'go', 'run', '%' },
}

-- Lleva registro de augroups para poder desactivar todo
M._groups = {}

-- === Helpers de UI (buffer de salida) ===
local function ensure_output_buf()
  -- Si ya estás en un scratch, úsalo
  local cur = vim.api.nvim_get_current_buf()
  if vim.bo[cur].buftype == 'nofile' then
    return cur
  end

  -- Split vertical dedicado a la salida
  vim.cmd 'vnew'
  local out = vim.api.nvim_get_current_buf()
  vim.bo[out].buftype = 'nofile'
  vim.bo[out].bufhidden = 'wipe'
  vim.bo[out].swapfile = false
  vim.bo[out].modifiable = true
  vim.bo[out].filetype = 'previewlog'
  return out
end

local function append_lines(buf, lines)
  if not lines or #lines == 0 then
    return
  end
  local was_mod = vim.bo[buf].modifiable
  if not was_mod then
    vim.bo[buf].modifiable = true
  end
  vim.api.nvim_buf_set_lines(buf, -1, -1, false, lines)
  if not was_mod then
    vim.bo[buf].modifiable = false
  end
end

local function reset_output(buf, header)
  local was_mod = vim.bo[buf].modifiable
  if not was_mod then
    vim.bo[buf].modifiable = true
  end
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { header, '' })
  if not was_mod then
    vim.bo[buf].modifiable = false
  end
end

-- === Helpers de ejecución ===
local function build_cmd(cmd_tmpl, file)
  local cmd = {}
  for _, v in ipairs(cmd_tmpl) do
    table.insert(cmd, v == '%' and file or v)
  end
  return cmd
end

local function is_executable(cmd)
  return vim.fn.executable(cmd[1]) == 1
end

-- === Core: attach ===
local function attach_preview(source_bufnr, output_bufnr, ft_to_cmd)
  local grp_name = ('Preview:%d'):format(source_bufnr)
  local aug = vim.api.nvim_create_augroup(grp_name, { clear = true })
  M._groups[grp_name] = true

  vim.api.nvim_create_autocmd('BufWritePost', {
    group = aug,
    buffer = source_bufnr, -- 👈 buffer-local
    desc = 'Preview on save (buffer-local)',
    callback = function(args)
      local ft = vim.bo[args.buf].filetype
      local cmd_tpl = (ft_to_cmd and ft_to_cmd[ft]) or DEFAULT_COMMANDS[ft]
      if not cmd_tpl then
        reset_output(output_bufnr, ('[%s] No hay comando configurado.'):format(ft))
        return
      end

      local file = vim.fn.expand '%:p'
      local cmd = build_cmd(cmd_tpl, file)

      if not is_executable(cmd) then
        reset_output(output_bufnr, ('[%s] Ejecutable no encontrado: "%s"'):format(ft, cmd[1]))
        return
      end

      reset_output(output_bufnr, ('%s output (%s):'):format(ft, vim.fn.fnamemodify(file, ':t')))

      vim.fn.jobstart(cmd, {
        stdout_buffered = true,
        stderr_buffered = true,
        on_stdout = function(_, data)
          append_lines(output_bufnr, data)
        end,
        on_stderr = function(_, data)
          append_lines(output_bufnr, data)
        end,
        on_exit = function(_, code)
          append_lines(output_bufnr, { '', ('[exit code %d]'):format(code) })
        end,
      })
    end,
  })
end

-- === Comandos públicos ===

-- :Preview [comando opcional...]
-- Ej: :Preview       -> usa DEFAULT_COMMANDS por filetype
--     :Preview deno run %   -> override solo para este buffer
M.preview_cmd = function(opts)
  local overrides = vim.deepcopy(DEFAULT_COMMANDS)
  local ft = vim.bo.filetype

  if opts and opts.args and #opts.args > 0 then
    -- Override simple separado por espacios (si necesitás quotes, puedes mejorar el split)
    local parts = vim.split(opts.args, '%s+', { trimempty = true })
    if #parts > 0 then
      overrides[ft] = parts
    end
  end

  local out = ensure_output_buf()
  local src = vim.api.nvim_get_current_buf()
  attach_preview(src, out, overrides)
  vim.notify('Preview habilitado para este buffer. Guardá el archivo para ver la salida.', vim.log.levels.INFO)
end

-- :PreviewStop -> desactiva la preview del buffer actual
M.preview_stop = function()
  local grp = ('Preview:%d'):format(vim.api.nvim_get_current_buf())
  local ok, err = pcall(vim.api.nvim_del_augroup_by_name, grp)
  if ok then
    M._groups[grp] = nil
    vim.notify('Preview deshabilitado en este buffer.', vim.log.levels.INFO)
  else
    vim.notify('No había Preview activo para este buffer. ' .. tostring(err or ''), vim.log.levels.WARN)
  end
end

-- :PreviewStopAll -> desactiva todas las previews creadas por este módulo
M.preview_stop_all = function()
  local count = 0
  for grp, _ in pairs(M._groups) do
    local ok = pcall(vim.api.nvim_del_augroup_by_name, grp)
    if ok then
      M._groups[grp] = nil
      count = count + 1
    end
  end
  vim.notify(('Preview deshabilitado en %d buffer(s).'):format(count), vim.log.levels.INFO)
end

-- :RemoveInlineComments -> remueve comentarios de línea según filetype
M.remove_inline_comments = function()
  local ft = vim.bo.filetype
  local map = {
    go = '//',
    javascript = '//',
    javascriptreact = '//',
    lua = '--',
    python = '#',
    typescript = '//',
    typescriptreact = '//',
  }
  local cc = map[ft]
  if not cc then
    vim.notify('No se encontró carácter de comentario para este filetype.', vim.log.levels.WARN)
    return
  end

  local function escape_vim_regex(s)
    return (s:gsub('([\\/^$.*+?()[%]-])', '\\%1'))
  end
  local esc = escape_vim_regex(cc)

  -- Sustitución buffer-local: elimina desde el comentario al final de cada línea
  vim.cmd(string.format([[%s/\v%s.*$//]], '%', esc))
end

-- === Definición de user commands ===
vim.api.nvim_create_user_command('Preview', function(opts)
  M.preview_cmd(opts)
end, {
  nargs = '*',
  desc = 'Ejecuta el archivo actual al guardar y muestra la salida en un scratch buffer (usa :vnew | :Preview).',
})

vim.api.nvim_create_user_command('PreviewStop', function()
  M.preview_stop()
end, {
  desc = 'Desactiva Preview en el buffer actual.',
})

vim.api.nvim_create_user_command('PreviewStopAll', function()
  M.preview_stop_all()
end, {
  desc = 'Desactiva todas las previews activas.',
})

vim.api.nvim_create_user_command('RemoveInlineComments', function()
  M.remove_inline_comments()
end, {
  desc = 'Remueve comentarios inline de las líneas según el filetype.',
})

return M
