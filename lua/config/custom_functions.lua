local M = {}

local DEFAULT_COMMANDS = {
  javascript = { 'node', '%' },
  javascriptreact = { 'node', '%' },
  typescript = { 'ts-node', '%' },
  typescriptreact = { 'ts-node', '%' },
  go = { 'go', 'run', '%' },
}

local function ensure_output_buf()
  local bufnr = vim.api.nvim_get_current_buf()
  if vim.bo[bufnr].buftype == 'nofile' then
    return bufnr
  end

  vim.cmd 'vnew'
  local out = vim.api.nvim_get_current_buf()
  vim.bo[out].buftype = 'nofile'
  vim.bo[out].bufhidden = 'wipe'
  vim.bo[out].swapfile = false
  vim.bo[out].modifiable = true
  vim.bo[out].filetype = 'previewlog'
  return out
end

local function build_cmd(cmd_tmpl, file)
  local cmd = {}
  for _, v in ipairs(cmd_tmpl) do
    if v == '%' then
      table.insert(cmd, file)
    else
      table.insert(cmd, v)
    end
  end
  return cmd
end

local function is_executable(cmd)
  local bin = cmd[1]
  return vim.fn.executable(bin) == 1
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

local function attach_preview(source_bufnr, output_bufnr, ft_to_cmd)
  local grp_name = string.format('Preview:%d', source_bufnr)
  local aug = vim.api.nvim_create_augroup(grp_name, { clear = true })

  vim.api.nvim_create_autocmd('BufWritePost', {
    group = aug,
    buffer = source_bufnr,
    callback = function(args)
      local ft = vim.bo[args.buf].filetype
      local cmd_tpl = (ft_to_cmd and ft_to_cmd[ft]) or DEFAULT_COMMANDS[ft]
      if not cmd_tpl then
        reset_output(output_bufnr, ('[%s] No hay comando configurado para este filetype.'):format(ft))
        return
      end

      local file = vim.fn.expand '%:p'
      local cmd = build_cmd(cmd_tpl, file)

      if not is_executable(cmd) then
        reset_output(output_bufnr, ('[%s] Ejecutable no encontrado: "%s" (instálalo o ajusta el comando).'):format(ft, cmd[1]))
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
    desc = 'Preview on save (buffer-local)',
  })
end

-- :Preview [filetype?]  -> permite override rápido del comando del FT actual
-- Uso recomendado: :vnew | :Preview
M.preview_cmd = function(opts)
  local ft = vim.bo.filetype
  local overrides = vim.deepcopy(DEFAULT_COMMANDS)

  if opts and opts.args and #opts.args > 0 then
    local parts = vim.split(opts.args, '%s+')
    overrides[ft] = parts
  end

  local out = ensure_output_buf()
  local src = vim.api.nvim_get_current_buf()
  attach_preview(src, out, overrides)
  vim.notify('Preview habilitado para este buffer. Guardá el archivo para ver la salida.', vim.log.levels.INFO)
end

-- :RemoveInlineComments -> remueve comentarios de línea (inline) según filetype
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

  local function lua_pat_escape(s)
    return (s:gsub('([%%%^%$%(%)%.%[%]%*%+%-%?])', '%%%1'))
  end
  local esc = lua_pat_escape(cc)
  vim.cmd(string.format([[%s/\v%s.*$//]], '%', esc))
end

vim.api.nvim_create_user_command('Preview', function(opts)
  M.preview_cmd(opts)
end, {
  nargs = '*',
  desc = 'Ejecuta el archivo actual al guardar y muestra la salida en un scratch buffer (usa :vnew | :Preview).',
})

vim.api.nvim_create_user_command('RemoveInlineComments', function()
  M.remove_inline_comments()
end, { desc = 'Remueve comentarios inline de las líneas según el filetype.' })

return M
