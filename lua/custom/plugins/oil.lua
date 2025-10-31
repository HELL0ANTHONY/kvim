vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = '*',
  callback = function()
    vim.api.nvim_set_hl(0, 'OilNormal', { bg = '#1d2021' }) -- por ejemplo gruvbox dark
  end,
})

return {
  'stevearc/oil.nvim',

  -- Defino la función ANTES (init corre antes que opts)
  init = function()
    -- Breadcrumb: mantiene últimos 2 segmentos; el resto "…/"
    local function shorten_tail(dir, keep)
      dir = dir:gsub('/+$', '')
      local parts = vim.split(dir, '/', { trimempty = true })
      local n = #parts

      if n <= keep then
        return dir
      end

      return '…/' .. table.concat(parts, '/', n - keep + 1, n)
    end

    _G.get_oil_winbar = function()
      local ok, oil = pcall(require, 'oil')

      if not ok or not oil.get_current_dir then
        return ''
      end

      local winid = tonumber(vim.g.statusline_winid or 0) or 0
      local bufnr = (winid > 0) and vim.api.nvim_win_get_buf(winid) or 0
      local dir = oil.get_current_dir(bufnr)

      if not dir then
        return ''
      end

      -- raíz de git si existe, sino cwd
      local git = vim.fs.find('.git', { path = dir, upward = true })[1]
      local root = git and vim.fs.dirname(git) or vim.loop.cwd()
      local shown = shorten_tail(dir, 3) -- ej: …/lua/plugins
      local project = vim.fn.fnamemodify(root or dir, ':t')

      return ('󰚌 %s  ›  %s'):format(project, shown ~= '' and shown or '.')
    end
  end,

  keys = {
    {
      '-',
      function()
        require('oil').toggle_float()
      end, -- reutiliza/cierran float

      desc = 'Open/close Oil in float',
    },
  },

  opts = {
    default_file_explorer = true,

    -- Ventana limpia y SIN números
    win_options = {
      number = false,
      relativenumber = false,
      signcolumn = 'no',
      winbar = '%{%v:lua.get_oil_winbar()%}', -- único lugar donde mostramos path
      winhighlight = 'Normal:OilNormal',
    },

    -- Título de la flotante vacío para no duplicar path
    float = {
      max_height = 15,
      max_width = 80,
      get_win_title = function(_)
        return ''
      end, -- oculta título. :contentReference[oaicite:6]{index=6}
    },

    -- Keymaps tuyos
    use_default_keymaps = false,
    keymaps = {
      ['g?'] = { 'actions.show_help', mode = 'n' },
      ['<CR>'] = 'actions.select',
      ['J'] = { 'actions.select', opts = { vertical = true } },
      ['K'] = { 'actions.select', opts = { horizontal = true } },
      ['T'] = { 'actions.select', opts = { tab = true } },
      ['<Tab>'] = 'actions.preview',
      ['q'] = { 'actions.close', mode = 'n' },
      ['<F5>'] = 'actions.refresh',
      ['-'] = { 'actions.parent', mode = 'n' },
      ['_'] = { 'actions.open_cwd', mode = 'n' },
      ['`'] = { 'actions.cd', mode = 'n' },
      ['~'] = { 'actions.cd', opts = { scope = 'tab' }, mode = 'n' },
      ['S'] = { 'actions.change_sort', mode = 'n' },
      ['gx'] = 'actions.open_external',
      ['H'] = { 'actions.toggle_hidden', mode = 'n' }, -- toggle ocultos. :contentReference[oaicite:7]{index=7}
      ['g\\'] = { 'actions.toggle_trash', mode = 'n' },

      -- Detalle bajo demanda (ahorra CPU)
      ['gd'] = {
        desc = 'Toggle file detail view',
        callback = (function()
          local detail = false
          return function()
            detail = not detail
            if detail then
              require('oil').set_columns { 'icon', 'permissions', 'size', 'mtime' } -- :contentReference[oaicite:8]{index=8}
            else
              require('oil').set_columns { 'icon' }
            end
          end
        end)(),
      },
    },

    -- Columns mínimas por defecto
    columns = { 'icon' }, -- recomendado en docs. :contentReference[oaicite:9]{index=9}

    view_options = {
      show_hidden = false, -- default off; H lo alterna. :contentReference[oaicite:10]{index=10}
      natural_order = 'fast', -- orden humano sin penalizar dirs grandes. :contentReference[oaicite:11]{index=11}
      sort = { { 'type', 'asc' }, { 'name', 'asc' } },
    },

    preview_win = {
      preview_method = 'fast_scratch', -- más liviano. :contentReference[oaicite:12]{index=12}
      update_on_cursor_moved = false,
    },

    lsp_file_methods = { enabled = false },
    watch_for_changes = false,
  },

  dependencies = {
    {
      'nvim-tree/nvim-web-devicons',
      cond = function()
        return vim.g.have_nerd_font == true
      end,
    },
    -- oil-vcs-status: si notas lag, déjalo fuera (es lo que más pesa al abrir repos).
  },
}
