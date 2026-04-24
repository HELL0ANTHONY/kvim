-- Native statusline — replaces lualine.nvim
-- Each component is a pure function: () -> string
-- Layout assembles components via vim statusline syntax (%! expression)

local M = {}

-- ── Highlight groups (SSOT for statusline colors) ──

local hl_defs = {
  StBranch = { fg = "#fb4934", bold = true },
  StFile = { bold = true },
  StModified = { fg = "#fabd2f", bold = true },
  StDiagE = { fg = "#fb4934" },
  StDiagW = { fg = "#fabd2f" },
  StDiagI = { fg = "#83a598" },
  StDiagH = { fg = "#8ec07c" },
  StDiffAdd = { fg = "#b8bb26" },
  StDiffMod = { fg = "#fabd2f" },
  StDiffDel = { fg = "#fb4934" },
  StPos = { fg = "#a89984" },
  StInactive = { fg = "#665c54" },
}

function M.setup_highlights()
  for name, def in pairs(hl_defs) do
    vim.api.nvim_set_hl(0, name, def)
  end
end

-- ── Filetypes that should NOT use custom statusline ──

local skip_ft = {
  TelescopePrompt = true,
  TelescopeResults = true,
  TelescopePreview = true,
  oil = true,
  lazy = true,
  mason = true,
  trouble = true,
  qf = true,
  help = true,
  man = true,
  Outline = true,
  harpoon = true,
  DiffviewFiles = true,
}

local function should_skip()
  if skip_ft[vim.bo.filetype] then
    return true
  end
  local bt = vim.bo.buftype
  if bt == "nofile" or bt == "prompt" or bt == "terminal" then
    return true
  end
  local cfg = vim.api.nvim_win_get_config(0)
  return cfg.relative ~= ""
end

-- ── Components ──

local function icon_for_file()
  local ok, dev = pcall(require, "nvim-web-devicons")
  if not ok then
    return ""
  end
  local name = vim.fn.expand("%:t")
  local ext = vim.fn.expand("%:e")
  local icon = dev.get_icon(name, ext, { default = true })
  return icon and (icon .. " ") or ""
end

function M.filename()
  local name = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":.")
  if name == "" then
    name = "[No Name]"
  end
  local modified = vim.bo.modified and " %#StModified#[󰦒]%#StFile#" or ""
  return "%#StFile# " .. icon_for_file() .. name .. modified .. " "
end

function M.branch()
  local head = vim.b.gitsigns_head
  if not head or head == "" then
    return ""
  end
  return "  " .. head .. " "
end

function M.diff()
  local s = vim.b.gitsigns_status_dict
  if not s then
    return ""
  end
  local parts = {}
  if (s.added or 0) > 0 then
    parts[#parts + 1] = " " .. s.added
  end
  if (s.changed or 0) > 0 then
    parts[#parts + 1] = " " .. s.changed
  end
  if (s.removed or 0) > 0 then
    parts[#parts + 1] = " " .. s.removed
  end
  if #parts == 0 then
    return ""
  end
  return table.concat(parts, " ") .. " "
end

function M.diagnostics()
  local d = vim.diagnostic.count(0)
  local parts = {}
  if (d[1] or 0) > 0 then
    parts[#parts + 1] = "  " .. d[1]
  end
  if (d[2] or 0) > 0 then
    parts[#parts + 1] = "  " .. d[2]
  end
  if (d[3] or 0) > 0 then
    parts[#parts + 1] = "  " .. d[3]
  end
  if (d[4] or 0) > 0 then
    parts[#parts + 1] = " 󰠠 " .. d[4]
  end
  if #parts == 0 then
    return ""
  end
  return table.concat(parts, " ") .. " "
end

function M.position()
  local l = vim.fn.line(".")
  local c = vim.fn.col(".")
  local total = vim.api.nvim_buf_line_count(0)
  return string.format("%%#StPos#󰉸 %d│󱥖 %d  %d ", l, c, total)
end

-- ── Short filename (solo nombre, sin ruta) ──

function M.filename_short()
  local name = vim.fn.expand("%:t")
  if name == "" then
    name = "[No Name]"
  end
  local modified = vim.bo.modified and " %#StModified#[󰦒]%#StFile#" or ""
  return "%#StFile# " .. icon_for_file() .. name .. modified .. " "
end

-- ── Layout (adapta al ancho de ventana) ──

function M.active()
  if should_skip() then
    return ""
  end
  local w = vim.api.nvim_win_get_width(0)

  if w < 50 then
    return M.filename_short()
  end

  if w < 80 then
    return table.concat({
      M.filename_short(),
      "%=",
      M.diagnostics(),
    })
  end

  if w < 120 then
    return table.concat({
      M.filename(),
      "%=",
      M.diagnostics(),
      M.position(),
    })
  end

  return table.concat({
    M.branch(),
    M.diff(),
    M.filename(),
    "%=",
    M.diagnostics(),
    M.position(),
  })
end

function M.inactive()
  if should_skip() then
    return ""
  end
  return table.concat({
    "%#StInactive#",
    M.filename_short(),
  })
end

-- ── Autocmds ──

function M.setup()
  M.setup_highlights()
  vim.api.nvim_create_autocmd("ColorScheme", {
    callback = M.setup_highlights,
  })

  local group =
    vim.api.nvim_create_augroup("NativeStatusline", { clear = true })

  vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
    group = group,
    callback = function()
      if should_skip() then
        return
      end
      vim.wo.statusline = "%!v:lua.require('config.statusline').active()"
    end,
  })

  vim.api.nvim_create_autocmd("WinLeave", {
    group = group,
    callback = function()
      if should_skip() then
        return
      end
      vim.wo.statusline = "%!v:lua.require('config.statusline').inactive()"
    end,
  })
end

return M
