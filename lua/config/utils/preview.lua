local M = {}

local DEFAULT_COMMANDS = {
  go = { "go", "run", "%" },
  javascript = { "node", "%" },
  javascriptreact = { "node", "%" },
  typescript = { "node", "--experimental-strip-types", "%" },
  typescriptreact = { "node", "--experimental-strip-types", "%" },
  python = { "python3", "%" },
  rust = { "cargo", "run", "--quiet" },
  lua = { "lua", "%" },
}

local active_previews = {} -- { [source_bufnr] = output_bufnr }

local function create_output_buf()
  vim.cmd("vnew")
  local buf = vim.api.nvim_get_current_buf()
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].swapfile = false
  vim.bo[buf].filetype = "preview_output"
  vim.api.nvim_buf_set_name(buf, "[Preview Output]")
  vim.cmd("wincmd p")
  return buf
end

local function write_to_buf(buf, lines, append)
  if not vim.api.nvim_buf_is_valid(buf) then
    return
  end
  vim.bo[buf].modifiable = true
  if append then
    vim.api.nvim_buf_set_lines(buf, -1, -1, false, lines)
  else
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  end
  vim.bo[buf].modifiable = false
end

local function run_preview(source_buf, output_buf)
  local ft = vim.bo[source_buf].filetype
  local cmd_template = DEFAULT_COMMANDS[ft]

  if not cmd_template then
    write_to_buf(output_buf, { "⚠ No hay comando para: " .. ft })
    return
  end

  local file = vim.api.nvim_buf_get_name(source_buf)
  local cmd = {}
  for _, v in ipairs(cmd_template) do
    table.insert(cmd, v == "%" and file or v)
  end

  if vim.fn.executable(cmd[1]) ~= 1 then
    write_to_buf(output_buf, { "⚠ Ejecutable no encontrado: " .. cmd[1] })
    return
  end

  write_to_buf(output_buf, {
    "▶ " .. table.concat(cmd, " "),
    "─────────────────────────────",
    "",
  })

  vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    stderr_buffered = true,
    on_stdout = function(_, data)
      if data and #data > 0 and data[1] ~= "" then
        vim.schedule(function()
          write_to_buf(output_buf, data, true)
        end)
      end
    end,
    on_stderr = function(_, data)
      if data and #data > 0 and data[1] ~= "" then
        vim.schedule(function()
          write_to_buf(output_buf, data, true)
        end)
      end
    end,
    on_exit = function(_, code)
      vim.schedule(function()
        local status = code == 0 and "✓ OK" or ("✗ Exit: " .. code)
        write_to_buf(
          output_buf,
          {
            "",
            "─────────────────────────────",
            status,
          },
          true
        )
      end)
    end,
  })
end

M.start = function()
  local source_buf = vim.api.nvim_get_current_buf()
  if active_previews[source_buf] then
    vim.notify("Preview ya activo en este buffer", vim.log.levels.WARN)
    return
  end

  local output_buf = create_output_buf()
  active_previews[source_buf] = output_buf

  local group =
    vim.api.nvim_create_augroup("Preview_" .. source_buf, { clear = true })

  vim.api.nvim_create_autocmd("BufWritePost", {
    group = group,
    buffer = source_buf,
    callback = function()
      if vim.api.nvim_buf_is_valid(output_buf) then
        run_preview(source_buf, output_buf)
      else
        M.stop()
      end
    end,
  })

  vim.api.nvim_create_autocmd("BufWipeout", {
    group = group,
    buffer = output_buf,
    callback = function()
      active_previews[source_buf] = nil
      pcall(vim.api.nvim_del_augroup_by_name, "Preview_" .. source_buf)
    end,
  })

  vim.notify("Preview activado", vim.log.levels.INFO)
  run_preview(source_buf, output_buf)
end

M.stop = function()
  local source_buf = vim.api.nvim_get_current_buf()
  if not active_previews[source_buf] then
    vim.notify("No hay preview activo", vim.log.levels.WARN)
    return
  end
  local output_buf = active_previews[source_buf]
  active_previews[source_buf] = nil
  pcall(vim.api.nvim_del_augroup_by_name, "Preview_" .. source_buf)
  if vim.api.nvim_buf_is_valid(output_buf) then
    vim.api.nvim_buf_delete(output_buf, { force = true })
  end
  vim.notify("Preview desactivado", vim.log.levels.INFO)
end

M.stop_all = function()
  local count = 0
  for source_buf, output_buf in pairs(active_previews) do
    pcall(vim.api.nvim_del_augroup_by_name, "Preview_" .. source_buf)
    if vim.api.nvim_buf_is_valid(output_buf) then
      vim.api.nvim_buf_delete(output_buf, { force = true })
    end
    count = count + 1
  end
  active_previews = {}
  vim.notify(("Desactivados %d previews"):format(count), vim.log.levels.INFO)
end

vim.api.nvim_create_user_command(
  "Preview",
  M.start,
  { desc = "Activa preview on save" }
)
vim.api.nvim_create_user_command(
  "PreviewStop",
  M.stop,
  { desc = "Desactiva preview" }
)
vim.api.nvim_create_user_command(
  "PreviewStopAll",
  M.stop_all,
  { desc = "Desactiva todos" }
)

return M
