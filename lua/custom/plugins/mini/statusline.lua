-- https://github.com/pkazmier/nvim
-- https://github.com/echasnovski/mini.nvim/discussions/1177#discussioncomment-10454003
-- https://github.com/echasnovski/mini.nvim/blob/2c55015a518e11ea9d49bb96078f5ede51f5d2af/doc/mini-statusline.txt#L87-L105
-- https://github.com/echasnovski/mini.statusline/blob/85014aa9e4afe9a3ff1896ad768bf09584bff574/lua/mini/statusline.lua#L308-L309
local H = {}
require('mini.statusline').setup {
  use_icons = true,
  content = {
    inactive = function()
      local pathname = H.section_pathname { trunc_width = 120 }
      return MiniStatusline.combine_groups {
        { hl = 'MiniStatuslineInactive', strings = { pathname } },
      }
    end,

    active = function()
      -- local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
      -- local lsp = MiniStatusline.section_lsp { trunc_width = 40 }
      -- local diff = MiniStatusline.section_diff { trunc_width = 60 }

      local diag_signs = { ERROR = ' ', WARN = ' ', INFO = ' ', HINT = ' ' }
      local _, mode_hl = MiniStatusline.section_mode { trunc_width = 120 }
      local git = MiniStatusline.section_git { trunc_width = 40 }
      local diff = H.section_diff { trunc_width = 60 }
      local diagnostics = MiniStatusline.section_diagnostics { trunc_width = 60, signs = diag_signs }
      local filetype = H.section_filetype { trunc_width = 70 }
      local location = H.section_location { trunc_width = 120 }
      local search = H.section_searchcount { trunc_width = 80 }
      local file_size = H.section_filesize { trunc_width = 80 }

      local pathname = H.section_pathname {
        trunc_width = 100,
        filename_hl = 'MiniStatuslineFilename',
        modified_hl = 'MiniStatuslineFilenameModified',
      }

      return MiniStatusline.combine_groups {
        -- { hl = mode_hl,                   strings = { mode:upper() } },
        { hl = mode_hl, strings = { git } },
        { hl = 'MiniStatuslineDevinfo', strings = { diff } },
        '%<', -- Mark general truncate point
        { hl = 'MiniStatuslineDirectory', strings = { pathname } },
        '%=', -- End left alignment
        { hl = 'MiniStatuslineFileinfo', strings = { filetype, diagnostics } },
        { hl = mode_hl, strings = { search .. file_size .. location } },
      }
    end,
  },
}

-- Utility from mini.statusline
H.isnt_normal_buffer = function()
  return vim.bo.buftype ~= ''
end

H.has_no_lsp_attached = function()
  return #vim.lsp.get_clients() == 0
end

H.get_filetype_icon = function()
  -- Have this `require()` here to not depend on plugin initialization order
  local has_devicons, devicons = pcall(require, 'nvim-web-devicons')
  if not has_devicons then
    return ''
  end

  local file_name, file_ext = vim.fn.expand '%:t', vim.fn.expand '%:e'
  return devicons.get_icon(file_name, file_ext, { default = true })
end

H.section_location = function(args)
  -- Use virtual column number to allow update when past last column
  if MiniStatusline.is_truncated(args.trunc_width) then
    return '%-2l│%-2v'
  end

  return '󰉸 %-2l│󱥖 %-2v'
end

H.section_filetype = function(args)
  if MiniStatusline.is_truncated(args.trunc_width) then
    return ''
  end

  local filetype = vim.bo.filetype
  if (filetype == '') or H.isnt_normal_buffer() then
    return ''
  end

  local icon = H.get_filetype_icon()
  if icon ~= '' then
    filetype = string.format('%s %s', icon, filetype)
  end

  return filetype
end

H.section_searchcount = function(args)
  if vim.v.hlsearch == 0 then
    return ''
  end

  local ok, s_count = pcall(vim.fn.searchcount, (args or {}).options or { recompute = true })
  if not ok or s_count.current == nil or s_count.total == 0 then
    return ''
  end

  local icon = MiniStatusline.is_truncated(args.trunc_width) and '' or ' '
  if s_count.incomplete == 1 then
    return icon .. '?/?│'
  end

  local too_many = ('>%d'):format(s_count.maxcount)
  local current = s_count.current > s_count.maxcount and too_many or s_count.current
  local total = s_count.total > s_count.maxcount and too_many or s_count.total
  return ('%s%s/%s│'):format(icon, current, total)
end

H.section_pathname = function(args)
  args = vim.tbl_extend('force', {
    modified_hl = nil,
    filename_hl = nil,
    trunc_width = 80,
  }, args or {})

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
  if require('mini.statusline').is_truncated(args.trunc_width) and #parts > 3 then
    parts = { parts[1], '…', parts[#parts - 1], parts[#parts] }
  end

  local dir = ''
  if #parts > 1 then
    dir = table.concat({ unpack(parts, 1, #parts - 1) }, sep) .. sep
  end

  local file = parts[#parts]
  local file_hl = ''
  if vim.bo.modified and args.modified_hl then
    file_hl = '%#' .. args.modified_hl .. '#'
  elseif args.filename_hl then
    file_hl = '%#' .. args.filename_hl .. '#'
  end
  local modified = vim.bo.modified and ' [+]' or ''
  return dir .. file_hl .. file .. modified
end

H.section_filesize = function(args)
  if MiniStatusline.is_truncated(args.trunc_width) then
    return ''
  end

  local fileinfo = MiniStatusline.section_fileinfo { trunc_width = 120 }
  local file_size = fileinfo:match '%d+%.?%d*%s?[KMG]?i?B$'
  file_size = file_size or ''

  if file_size == '' then
    return ''
  end
  local icon = '  '

  return string.format('%s%s │ ', icon, file_size)
end

H.section_diff = function(args)
  if MiniStatusline.is_truncated(args.trunc_width) then
    return ''
  end

  local diff_signs = {
    -- added = '%#DiffAdded# ',
    -- changed = '%#DiffChanged# ',
    -- removed = '%#DiffRemoved# ',

    added = ' ',
    changed = ' ',
    removed = ' ',
  }

  local gitsigns_dict = vim.b.gitsigns_status_dict
  if not gitsigns_dict then
    return ''
  end

  local added = gitsigns_dict.added or 0
  local changed = gitsigns_dict.changed or 0
  local removed = gitsigns_dict.removed or 0

  local diff = {}

  if added > 0 then
    table.insert(diff, diff_signs.added .. added)
  end
  if changed > 0 then
    table.insert(diff, diff_signs.changed .. changed)
  end
  if removed > 0 then
    table.insert(diff, diff_signs.removed .. removed)
  end

  return table.concat(diff, ' ')
end

return H
