-- https://github.com/pkazmier/nvim
-- https://github.com/echasnovski/mini.nvim/discussions/1177#discussioncomment-10454003
-- https://github.com/echasnovski/mini.nvim/blob/2c55015a518e11ea9d49bb96078f5ede51f5d2af/doc/mini-statusline.txt#L87-L105
-- https://github.com/echasnovski/mini.statusline/blob/85014aa9e4afe9a3ff1896ad768bf09584bff574/lua/mini/statusline.lua#L308-L309
local H = {}
local MiniStatusline = require 'mini.statusline'

vim.api.nvim_set_hl(0, 'MiniStatuslineInactive', { bg = '#3c3836' })
vim.api.nvim_set_hl(0, 'MiniStatuslineDevinfo', { bg = '#3c3836' })
vim.api.nvim_set_hl(0, 'MiniStatuslineDirectory', { bg = '#3c3836' })
vim.api.nvim_set_hl(0, 'MiniStatuslineFileinfo', { bg = '#3c3836' })
vim.api.nvim_set_hl(0, 'MiniStatuslineModeNormal', { bg = '#3c3836' })
vim.api.nvim_set_hl(0, 'MiniStatuslineModeInsert', { bg = '#3c3836' })
vim.api.nvim_set_hl(0, 'MiniStatuslineModeVisual', { bg = '#3c3836' })

MiniStatusline.setup {
  use_icons = true,
  content = {
    inactive = function()
      return MiniStatusline.combine_groups {
        { hl = 'MiniStatuslineInactive', strings = { H.get_pathname { trunc_width = 120 } } },
      }
    end,
    active = function()
      local mode_hl = H.get_mode_highlight()
      local git_info = H.get_git_info()
      local diff_info = H.get_diff_info()
      local diagnostics_info = H.get_diagnostics_info()
      local filetype_info = H.get_filetype_info()
      local location_info = H.get_location_info()
      local search_info = H.get_search_count()
      local filesize_info = H.get_filesize_info()

      return MiniStatusline.combine_groups {
        { hl = 'MiniStatuslineDevinfo', strings = { git_info } },
        { hl = 'MiniStatuslineDevinfo', strings = { diff_info } },
        '%<', -- Punto general de truncamiento
        { hl = 'MiniStatuslineDirectory', strings = { H.get_pathname { trunc_width = 100 } } },
        '%=', -- Fin de la alineación izquierda
        { hl = 'MiniStatuslineFileinfo', strings = { filetype_info, diagnostics_info } },
        { hl = 'MiniStatuslineDevinfo', strings = { search_info .. filesize_info .. location_info } },
      }
    end,
  },
}

-- Funciones utilitarias
H.isnt_normal_buffer = function()
  return vim.bo.buftype ~= ''
end

H.has_no_lsp_attached = function()
  return #vim.lsp.get_clients() == 0
end

H.get_filetype_icon = function()
  local has_devicons, devicons = pcall(require, 'nvim-web-devicons')
  if not has_devicons then
    return ''
  end

  local file_name, file_ext = vim.fn.expand '%:t', vim.fn.expand '%:e'
  return devicons.get_icon(file_name, file_ext, { default = true })
end

H.get_mode_highlight = function()
  return MiniStatusline.section_mode { trunc_width = 120 }
end

H.get_git_info = function()
  return MiniStatusline.section_git { trunc_width = 40 }
end

H.get_diagnostics_info = function()
  local diag_signs = { ERROR = ' ', WARN = ' ', INFO = ' ', HINT = '󱐋 ' }
  return MiniStatusline.section_diagnostics { trunc_width = 60, signs = diag_signs }
end

H.get_location_info = function()
  if MiniStatusline.is_truncated(120) then
    return '%-2l│%-2v'
  end
  return '󰉸 %-2l│󱥖 %-2v'
end

H.get_filetype_info = function()
  if MiniStatusline.is_truncated(70) or H.isnt_normal_buffer() then
    return ''
  end

  local filetype = vim.bo.filetype
  local icon = H.get_filetype_icon()
  return icon ~= '' and string.format('%s %s', icon, filetype) or filetype
end

H.get_search_count = function()
  if vim.v.hlsearch == 0 then
    return ''
  end

  local ok, s_count = pcall(vim.fn.searchcount, { recompute = true })
  if not ok or s_count.current == nil or s_count.total == 0 then
    return ''
  end

  local icon = MiniStatusline.is_truncated(80) and '' or ' '
  local current = s_count.current > s_count.maxcount and ('>%d'):format(s_count.maxcount) or s_count.current
  local total = s_count.total > s_count.maxcount and ('>%d'):format(s_count.maxcount) or s_count.total

  return string.format('%s%s/%s│', icon, current, total)
end

H.get_pathname = function(args)
  args = vim.tbl_extend('force', { modified_hl = nil, filename_hl = nil, trunc_width = 80 }, args or {})

  if vim.bo.buftype == 'terminal' then
    return '%t'
  end

  local path = vim.fn.expand '%:p'
  local cwd = vim.uv.cwd() or ''
  cwd = vim.uv.fs_realpath(cwd) or ''

  if path:find(cwd, 1, true) == 1 then
    path = path:sub(#cwd + 2)
  end

  local sep = package.config:sub(1, 1)
  local parts = vim.split(path, sep)

  if MiniStatusline.is_truncated(args.trunc_width) and #parts > 3 then
    parts = { parts[1], '…', parts[#parts - 1], parts[#parts] }
  end

  local dir = #parts > 1 and table.concat(parts, sep, 1, #parts - 1) .. sep or ''
  local file = parts[#parts]
  local modified = vim.bo.modified and ' [+]' or ''
  local file_hl = ''

  if vim.bo.modified and args.modified_hl then
    file_hl = '%#' .. args.modified_hl .. '#'
  elseif args.filename_hl then
    file_hl = '%#' .. args.filename_hl .. '#'
  end

  return dir .. file_hl .. file .. modified
end

H.get_filesize_info = function()
  if MiniStatusline.is_truncated(80) then
    return ''
  end

  local file_info = MiniStatusline.section_fileinfo { trunc_width = 120 }
  local file_size = file_info:match '%d+%.?%d*%s?[KMG]?i?B$' or ''
  return file_size ~= '' and string.format('  %s │ ', file_size) or ''
end

H.get_diff_info = function()
  if MiniStatusline.is_truncated(60) then
    return ''
  end

  local diff_signs = {
    added = ' ',
    changed = ' ',
    removed = ' ',
  }

  local gitsigns_dict = vim.b.gitsigns_status_dict
  if not gitsigns_dict then
    return ''
  end

  local diff = {}
  for k, v in pairs(diff_signs) do
    if gitsigns_dict[k] and gitsigns_dict[k] > 0 then
      table.insert(diff, v .. gitsigns_dict[k])
    end
  end

  return table.concat(diff, ' ')
end

return H
