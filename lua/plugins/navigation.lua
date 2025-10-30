return {
  {
    'phaazon/hop.nvim',
    branch = 'v2',
    keys = function()
      return {
        {
          '<leader>ww',
          function()
            require('hop').hint_words()
          end,
          desc = '[w]orkspace: jump to [w]ord',
        },
        {
          '<leader>wl',
          function()
            require('hop').hint_lines()
          end,
          desc = '[w]orkspace: jump to [l]ine',
        },
        {
          '<leader>wW',
          function()
            require('hop').hint_words { multi_windows = true }
          end,
          desc = '[w]orkspace: jump to [W]ord (multi-window)',
        },
        {
          '<leader>wF',
          function()
            local directions = require('hop.hint').HintDirection

            require('hop').hint_char1 {
              direction = directions.BEFORE_CURSOR,
              current_line_only = true,
            }
          end,
          desc = '[w]orkspace: jump to [F] character before cursor (current line)',
        },
        {
          '<leader>wf',
          function()
            local directions = require('hop.hint').HintDirection

            require('hop').hint_char1 {
              direction = directions.AFTER_CURSOR,
              current_line_only = true,
            }
          end,
          desc = '[w]orkspace: jump to [f] character after cursor (current line)',
        },
      }
    end,
    opts = {
      keys = 'etovxqpdygfblzhckisuran',
    },
  },
  {
    'SmiteshP/nvim-navbuddy',
    dependencies = {
      'SmiteshP/nvim-navic',
      'MunifTanjim/nui.nvim',
      'neovim/nvim-lspconfig',
      'nvim-telescope/telescope.nvim',
    },
    keys = {
      {
        '<leader>os',
        function()
          require('nvim-navbuddy').open()
        end,
        desc = 'LSP: [o]pen [s]ymbols navigation',
        mode = 'n',
      },
    },
    config = function()
      require('nvim-navbuddy').setup {
        window = { border = 'rounded' },
        -- icons = require('george.icons').kind,
        lsp = { auto_attach = true },
      }
    end,
  },
  {
    'stevearc/oil.nvim',
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
  },
  {
    'ThePrimeagen/harpoon',
    dependencies = { 'nvim-lua/plenary.nvim' },
    branch = 'harpoon2',
    config = function()
      local harpoon = require 'harpoon'
      harpoon:setup {
        settings = {
          save_on_toggle = true,
          sync_on_ui_close = true,
          -- key = function()
          --   return vim.loop.cwd()
          -- end,
        },
      }

      harpoon:extend {
        UI_CREATE = function(cx)
          vim.keymap.set('n', 'J', function()
            harpoon.ui:select_menu_item { vsplit = true }
          end, { buffer = cx.bufnr })

          vim.keymap.set('n', 'K', function()
            harpoon.ui:select_menu_item { split = true }
          end, { buffer = cx.bufnr })

          -- Abrir en la ventana actual con Enter
          vim.keymap.set('n', '<CR>', function()
            harpoon.ui:select_menu_item()
          end, { buffer = cx.bufnr })

          -- Abrir en una nueva pestaña con Ctrl+t
          vim.keymap.set('n', '<C-t>', function()
            harpoon.ui:select_menu_item { tabedit = true }
          end, { buffer = cx.bufnr })
        end,
      }
    end,
    opts = {
      menu = {
        -- width = vim.api.nvim_win_get_width(0) - 4,
        width = math.floor(vim.api.nvim_win_get_width(0) * 0.5),
      },
      settings = {
        save_on_toggle = true,
      },
    },
    keys = function()
      local keys = {
        {
          '<leader>+',
          function()
            require('harpoon'):list():add()
          end,
          desc = 'Harpoon File',
        },
        {
          '<leader>=',
          function()
            local harpoon = require 'harpoon'
            harpoon.ui:toggle_quick_menu(harpoon:list())
          end,
          desc = 'Harpoon Quick Menu',
        },
      }

      for i = 1, 5 do
        table.insert(keys, {
          '<leader>' .. i,
          function()
            require('harpoon'):list():select(i)
          end,
          desc = 'Harpoon to File ' .. i,
        })
      end
      return keys
    end,
  },
}
