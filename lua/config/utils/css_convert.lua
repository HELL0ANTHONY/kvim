local M = {}

-- ============================================================================
-- CONFIGURACIÓN
-- ============================================================================
local REM_BASE = 16
local VIEWPORT_WIDTH = 1920 -- Para cálculos vw
local VIEWPORT_HEIGHT = 1080 -- Para cálculos vh

-- ============================================================================
-- PATRONES
-- ============================================================================
local patterns = {
  px = '([%d%.]+)px',
  rem = '([%d%.]+)rem',
  em = '([%d%.]+)em',
  vh = '([%d%.]+)vh',
  vw = '([%d%.]+)vw',
  percent = '([%d%.]+)%%',
  hex6 = '#([%x][%x])([%x][%x])([%x][%x])',
  hex3 = '#([%x])([%x])([%x])',
  hex8 = '#([%x][%x])([%x][%x])([%x][%x])([%x][%x])',
  rgb = 'rgb%((%d+),%s*(%d+),%s*(%d+)%)',
  rgba = 'rgba%((%d+),%s*(%d+),%s*(%d+),%s*([%d%.]+)%)',
  hsl = 'hsl%((%d+),%s*(%d+)%%,%s*(%d+)%%%)',
  hsla = 'hsla%((%d+),%s*(%d+)%%,%s*(%d+)%%,%s*([%d%.]+)%)',
}

-- ============================================================================
-- HELPERS
-- ============================================================================
local function round(num, decimals)
  local mult = 10 ^ (decimals or 0)
  return math.floor(num * mult + 0.5) / mult
end

local function clamp(val, min, max)
  return math.max(min, math.min(max, val))
end

-- ============================================================================
-- CONVERSIONES DE UNIDADES
-- ============================================================================
local unit_conversions = {
  px_to_rem = function(v)
    return string.format('%.4grem', v / REM_BASE)
  end,
  rem_to_px = function(v)
    return string.format('%gpx', v * REM_BASE)
  end,
  px_to_em = function(v)
    return string.format('%.4gem', v / REM_BASE)
  end,
  em_to_px = function(v)
    return string.format('%gpx', v * REM_BASE)
  end,
  px_to_vw = function(v)
    return string.format('%.2fvw', (v / VIEWPORT_WIDTH) * 100)
  end,
  vw_to_px = function(v)
    return string.format('%gpx', round((v / 100) * VIEWPORT_WIDTH))
  end,
  px_to_vh = function(v)
    return string.format('%.2fvh', (v / VIEWPORT_HEIGHT) * 100)
  end,
  vh_to_px = function(v)
    return string.format('%gpx', round((v / 100) * VIEWPORT_HEIGHT))
  end,
}

-- ============================================================================
-- CONVERSIONES DE COLORES
-- ============================================================================

-- HEX -> RGB
local function hex_to_rgb(hex)
  hex = hex:gsub('#', '')
  if #hex == 3 then
    hex = hex:sub(1, 1):rep(2) .. hex:sub(2, 2):rep(2) .. hex:sub(3, 3):rep(2)
  end
  local r = tonumber(hex:sub(1, 2), 16)
  local g = tonumber(hex:sub(3, 4), 16)
  local b = tonumber(hex:sub(5, 6), 16)
  local a = #hex == 8 and tonumber(hex:sub(7, 8), 16) / 255 or nil
  return r, g, b, a
end

-- RGB -> HEX
local function rgb_to_hex(r, g, b, a)
  if a and a < 1 then
    return string.format('#%02x%02x%02x%02x', r, g, b, math.floor(a * 255))
  end
  return string.format('#%02x%02x%02x', r, g, b)
end

-- RGB -> HSL
local function rgb_to_hsl(r, g, b)
  r, g, b = r / 255, g / 255, b / 255
  local max, min = math.max(r, g, b), math.min(r, g, b)
  local h, s, l = 0, 0, (max + min) / 2

  if max ~= min then
    local d = max - min
    s = l > 0.5 and d / (2 - max - min) or d / (max + min)
    if max == r then
      h = (g - b) / d + (g < b and 6 or 0)
    elseif max == g then
      h = (b - r) / d + 2
    else
      h = (r - g) / d + 4
    end
    h = h / 6
  end

  return round(h * 360), round(s * 100), round(l * 100)
end

-- HSL -> RGB
local function hsl_to_rgb(h, s, l)
  h, s, l = h / 360, s / 100, l / 100
  local r, g, b

  if s == 0 then
    r, g, b = l, l, l
  else
    local function hue2rgb(p, q, t)
      if t < 0 then
        t = t + 1
      end
      if t > 1 then
        t = t - 1
      end
      if t < 1 / 6 then
        return p + (q - p) * 6 * t
      end
      if t < 1 / 2 then
        return q
      end
      if t < 2 / 3 then
        return p + (q - p) * (2 / 3 - t) * 6
      end
      return p
    end
    local q = l < 0.5 and l * (1 + s) or l + s - l * s
    local p = 2 * l - q
    r = hue2rgb(p, q, h + 1 / 3)
    g = hue2rgb(p, q, h)
    b = hue2rgb(p, q, h - 1 / 3)
  end

  return round(r * 255), round(g * 255), round(b * 255)
end

-- ============================================================================
-- DETECCIÓN BAJO CURSOR
-- ============================================================================
local function get_match_under_cursor(pattern_list)
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2] + 1

  for _, pinfo in ipairs(pattern_list) do
    local start_pos = 1
    while true do
      local matches = { line:find(pinfo.pattern, start_pos) }
      if not matches[1] then
        break
      end

      local match_start, match_end = matches[1], matches[2]
      if col >= match_start and col <= match_end then
        return {
          type = pinfo.type,
          full_match = line:sub(match_start, match_end),
          captures = { select(3, unpack(matches)) },
          start_col = match_start,
          end_col = match_end,
          line = line,
        }
      end
      start_pos = match_end + 1
    end
  end
  return nil
end

local function replace_match(match, new_value)
  local before = match.line:sub(1, match.start_col - 1)
  local after = match.line:sub(match.end_col + 1)
  vim.api.nvim_set_current_line(before .. new_value .. after)
end

-- ============================================================================
-- FUNCIONES PÚBLICAS - UNIDADES
-- ============================================================================

M.toggle_px_rem = function()
  local match = get_match_under_cursor {
    { pattern = patterns.px, type = 'px' },
    { pattern = patterns.rem, type = 'rem' },
    { pattern = patterns.em, type = 'em' },
  }

  if not match then
    vim.notify('No se encontró px/rem/em bajo el cursor', vim.log.levels.WARN)
    return
  end

  local value = tonumber(match.captures[1])
  local new_value

  if match.type == 'px' then
    new_value = unit_conversions.px_to_rem(value)
  elseif match.type == 'rem' then
    new_value = unit_conversions.rem_to_px(value)
  elseif match.type == 'em' then
    new_value = unit_conversions.em_to_px(value)
  end

  replace_match(match, new_value)
  vim.notify(match.full_match .. ' → ' .. new_value, vim.log.levels.INFO)
end

M.toggle_px_vw = function()
  local match = get_match_under_cursor {
    { pattern = patterns.px, type = 'px' },
    { pattern = patterns.vw, type = 'vw' },
  }

  if not match then
    vim.notify('No se encontró px/vw bajo el cursor', vim.log.levels.WARN)
    return
  end

  local value = tonumber(match.captures[1])
  local new_value = match.type == 'px' and unit_conversions.px_to_vw(value) or unit_conversions.vw_to_px(value)

  replace_match(match, new_value)
  vim.notify(match.full_match .. ' → ' .. new_value, vim.log.levels.INFO)
end

M.toggle_px_vh = function()
  local match = get_match_under_cursor {
    { pattern = patterns.px, type = 'px' },
    { pattern = patterns.vh, type = 'vh' },
  }

  if not match then
    vim.notify('No se encontró px/vh bajo el cursor', vim.log.levels.WARN)
    return
  end

  local value = tonumber(match.captures[1])
  local new_value = match.type == 'px' and unit_conversions.px_to_vh(value) or unit_conversions.vh_to_px(value)

  replace_match(match, new_value)
  vim.notify(match.full_match .. ' → ' .. new_value, vim.log.levels.INFO)
end

-- ============================================================================
-- FUNCIONES PÚBLICAS - COLORES
-- ============================================================================

M.toggle_color_format = function()
  local match = get_match_under_cursor {
    { pattern = patterns.hex8, type = 'hex8' },
    { pattern = patterns.hex6, type = 'hex6' },
    { pattern = patterns.hex3, type = 'hex3' },
    { pattern = patterns.rgba, type = 'rgba' },
    { pattern = patterns.rgb, type = 'rgb' },
    { pattern = patterns.hsla, type = 'hsla' },
    { pattern = patterns.hsl, type = 'hsl' },
  }

  if not match then
    vim.notify('No se encontró color bajo el cursor', vim.log.levels.WARN)
    return
  end

  local new_value
  local c = match.captures

  if match.type == 'hex6' or match.type == 'hex3' then
    -- HEX -> RGB
    local r, g, b = hex_to_rgb(match.full_match)
    new_value = string.format('rgb(%d, %d, %d)', r, g, b)
  elseif match.type == 'hex8' then
    -- HEX8 -> RGBA
    local r, g, b, a = hex_to_rgb(match.full_match)
    new_value = string.format('rgba(%d, %d, %d, %.2g)', r, g, b, a)
  elseif match.type == 'rgb' then
    -- RGB -> HSL
    local h, s, l = rgb_to_hsl(tonumber(c[1]), tonumber(c[2]), tonumber(c[3]))
    new_value = string.format('hsl(%d, %d%%, %d%%)', h, s, l)
  elseif match.type == 'rgba' then
    -- RGBA -> HSLA
    local h, s, l = rgb_to_hsl(tonumber(c[1]), tonumber(c[2]), tonumber(c[3]))
    new_value = string.format('hsla(%d, %d%%, %d%%, %s)', h, s, l, c[4])
  elseif match.type == 'hsl' then
    -- HSL -> HEX
    local r, g, b = hsl_to_rgb(tonumber(c[1]), tonumber(c[2]), tonumber(c[3]))
    new_value = rgb_to_hex(r, g, b)
  elseif match.type == 'hsla' then
    -- HSLA -> HEX8
    local r, g, b = hsl_to_rgb(tonumber(c[1]), tonumber(c[2]), tonumber(c[3]))
    new_value = rgb_to_hex(r, g, b, tonumber(c[4]))
  end

  replace_match(match, new_value)
  vim.notify(match.full_match .. ' → ' .. new_value, vim.log.levels.INFO)
end

M.color_to_hex = function()
  local match = get_match_under_cursor {
    { pattern = patterns.rgba, type = 'rgba' },
    { pattern = patterns.rgb, type = 'rgb' },
    { pattern = patterns.hsla, type = 'hsla' },
    { pattern = patterns.hsl, type = 'hsl' },
  }

  if not match then
    vim.notify('No se encontró rgb/hsl bajo el cursor', vim.log.levels.WARN)
    return
  end

  local c = match.captures
  local r, g, b, a

  if match.type == 'rgb' then
    r, g, b = tonumber(c[1]), tonumber(c[2]), tonumber(c[3])
  elseif match.type == 'rgba' then
    r, g, b, a = tonumber(c[1]), tonumber(c[2]), tonumber(c[3]), tonumber(c[4])
  elseif match.type == 'hsl' then
    r, g, b = hsl_to_rgb(tonumber(c[1]), tonumber(c[2]), tonumber(c[3]))
  elseif match.type == 'hsla' then
    r, g, b = hsl_to_rgb(tonumber(c[1]), tonumber(c[2]), tonumber(c[3]))
    a = tonumber(c[4])
  end

  local new_value = rgb_to_hex(r, g, b, a)
  replace_match(match, new_value)
  vim.notify(match.full_match .. ' → ' .. new_value, vim.log.levels.INFO)
end

-- ============================================================================
-- FUNCIONES BATCH (TODO EL ARCHIVO)
-- ============================================================================

M.all_px_to_rem = function()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local count = 0

  for i, line in ipairs(lines) do
    lines[i] = line:gsub(patterns.px, function(v)
      count = count + 1
      return unit_conversions.px_to_rem(tonumber(v))
    end)
  end

  if count > 0 then
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
    vim.notify(string.format('Convertidos %d valores px → rem', count), vim.log.levels.INFO)
  else
    vim.notify('No se encontraron valores en px', vim.log.levels.INFO)
  end
end

M.all_rem_to_px = function()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local count = 0

  for i, line in ipairs(lines) do
    lines[i] = line:gsub(patterns.rem, function(v)
      count = count + 1
      return unit_conversions.rem_to_px(tonumber(v))
    end)
  end

  if count > 0 then
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
    vim.notify(string.format('Convertidos %d valores rem → px', count), vim.log.levels.INFO)
  else
    vim.notify('No se encontraron valores en rem', vim.log.levels.INFO)
  end
end

M.all_hex_to_rgb = function()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local count = 0

  for i, line in ipairs(lines) do
    -- Hex de 6 dígitos
    lines[i] = line:gsub('#([%x][%x])([%x][%x])([%x][%x])', function(r, g, b)
      count = count + 1
      return string.format('rgb(%d, %d, %d)', tonumber(r, 16), tonumber(g, 16), tonumber(b, 16))
    end)
  end

  if count > 0 then
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
    vim.notify(string.format('Convertidos %d colores hex → rgb', count), vim.log.levels.INFO)
  else
    vim.notify('No se encontraron colores hex', vim.log.levels.INFO)
  end
end

-- ============================================================================
-- CONFIGURACIÓN
-- ============================================================================

M.set_rem_base = function(base)
  REM_BASE = base or 16
  vim.notify('REM base: ' .. REM_BASE .. 'px', vim.log.levels.INFO)
end

M.set_viewport = function(width, height)
  VIEWPORT_WIDTH = width or 1920
  VIEWPORT_HEIGHT = height or 1080
  vim.notify(string.format('Viewport: %dx%d', VIEWPORT_WIDTH, VIEWPORT_HEIGHT), vim.log.levels.INFO)
end

-- ============================================================================
-- USER COMMANDS
-- ============================================================================

-- Unidades
vim.api.nvim_create_user_command('CssToggle', M.toggle_px_rem, {
  desc = 'Toggle px <-> rem/em',
})
vim.api.nvim_create_user_command('CssToggleVw', M.toggle_px_vw, {
  desc = 'Toggle px <-> vw',
})
vim.api.nvim_create_user_command('CssToggleVh', M.toggle_px_vh, {
  desc = 'Toggle px <-> vh',
})

-- Colores
vim.api.nvim_create_user_command('ColorToggle', M.toggle_color_format, {
  desc = 'Ciclo: hex -> rgb -> hsl -> hex',
})
vim.api.nvim_create_user_command('ColorToHex', M.color_to_hex, {
  desc = 'Convierte rgb/hsl a hex',
})

-- Batch
vim.api.nvim_create_user_command('CssAllPxToRem', M.all_px_to_rem, {
  desc = 'Todos los px -> rem',
})
vim.api.nvim_create_user_command('CssAllRemToPx', M.all_rem_to_px, {
  desc = 'Todos los rem -> px',
})
vim.api.nvim_create_user_command('ColorAllHexToRgb', M.all_hex_to_rgb, {
  desc = 'Todos los hex -> rgb',
})

-- Config
vim.api.nvim_create_user_command('CssSetBase', function(opts)
  M.set_rem_base(tonumber(opts.args))
end, { nargs = 1, desc = 'Set rem base (default 16)' })

vim.api.nvim_create_user_command('CssSetViewport', function(opts)
  local args = vim.split(opts.args, '%s+')
  M.set_viewport(tonumber(args[1]), tonumber(args[2]))
end, { nargs = '+', desc = 'Set viewport width height' })

return M
