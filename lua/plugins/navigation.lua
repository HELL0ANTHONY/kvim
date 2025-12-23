return {
  -- Flash en lugar de Hop (con tus shortcuts)
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    opts = {
      labels = 'etovxqpdygfblzhckisuran', -- tus labels originales
      modes = {
        char = { enabled = false }, -- desactiva f/F/t/T nativos para usar los tuyos
      },
    },
    keys = {
      {
        '<leader>ww',
        function()
          require('flash').jump()
        end,
        mode = { 'n', 'x', 'o' },
        desc = '[w]orkspace: jump to [w]ord',
      },
      {
        '<leader>wl',
        function()
          require('flash').jump { search = { mode = 'search' }, pattern = '^' }
        end,
        mode = { 'n', 'x', 'o' },
        desc = '[w]orkspace: jump to [l]ine',
      },
      {
        '<leader>wW',
        function()
          require('flash').jump { search = { multi_window = true } }
        end,
        mode = { 'n', 'x', 'o' },
        desc = '[w]orkspace: jump to [W]ord (multi-window)',
      },
      {
        '<leader>wf',
        function()
          require('flash').jump {
            search = { mode = 'search', max_length = 1, forward = true },
            pattern = '',
            labels = 'etovxqpdygfblzhckisuran',
          }
        end,
        mode = { 'n', 'x', 'o' },
        desc = '[w]orkspace: jump to [f] char after cursor',
      },
      {
        '<leader>wF',
        function()
          require('flash').jump {
            search = { mode = 'search', max_length = 1, forward = false },
            pattern = '',
            labels = 'etovxqpdygfblzhckisuran',
          }
        end,
        mode = { 'n', 'x', 'o' },
        desc = '[w]orkspace: jump to [F] char before cursor',
      },
      {
        '<leader>wt',
        function()
          require('flash').treesitter()
        end,
        mode = { 'n', 'x', 'o' },
        desc = '[w]orkspace: select [t]reesitter node',
      },
    },
  },

  {
    'stevearc/oil.nvim',
    init = function()
      -- Highlight para Oil
      vim.api.nvim_create_autocmd('ColorScheme', {
        pattern = '*',
        callback = function()
          vim.api.nvim_set_hl(0, 'OilNormal', { bg = '#1d2021' })
        end,
      })
      -- Aplicar inmediatamente si el colorscheme ya cargó
      vim.api.nvim_set_hl(0, 'OilNormal', { bg = '#1d2021' })

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

        local git = vim.fs.find('.git', { path = dir, upward = true })[1]
        local root = git and vim.fs.dirname(git) or vim.uv.cwd() -- ✅ vim.uv
        local shown = shorten_tail(dir, 4)
        local project = vim.fn.fnamemodify(root or dir, ':t')

        return ('󰚌 %s  ›  %s'):format(project, shown ~= '' and shown or '.')
      end
    end,

    keys = {
      {
        '-',
        function()
          require('oil').toggle_float()
        end,
        desc = 'Open/close Oil in float',
      },
    },

    opts = {
      default_file_explorer = true,
      win_options = {
        number = false,
        relativenumber = false,
        signcolumn = 'no',
        winbar = '%{%v:lua.get_oil_winbar()%}',
        winhighlight = 'Normal:OilNormal',
      },
      float = {
        max_height = 25,
        max_width = 60,
        border = 'rounded',
        get_win_title = function()
          return ''
        end,
      },
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
        ['H'] = { 'actions.toggle_hidden', mode = 'n' },
        ['g\\'] = { 'actions.toggle_trash', mode = 'n' },
        ['gd'] = {
          desc = 'Toggle file detail view',
          callback = (function()
            local detail = false
            return function()
              detail = not detail
              if detail then
                require('oil').set_columns { 'icon', 'permissions', 'size', 'mtime' }
              else
                require('oil').set_columns { 'icon' }
              end
            end
          end)(),
        },
      },
      columns = { 'icon' },
      view_options = {
        show_hidden = false,
        natural_order = 'fast',
        sort = { { 'type', 'asc' }, { 'name', 'asc' } },
      },
      preview_win = {
        preview_method = 'fast_scratch',
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
          vim.keymap.set('n', '<CR>', function()
            harpoon.ui:select_menu_item()
          end, { buffer = cx.bufnr })
          vim.keymap.set('n', '<C-t>', function()
            harpoon.ui:select_menu_item { tabedit = true }
          end, { buffer = cx.bufnr })
        end,
      }
    end,
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
            -- local width = math.floor(vim.api.nvim_win_get_width(0) * 0.5)
            harpoon.ui:toggle_quick_menu(harpoon:list(), { ui_width_ratio = 0.5 })
          end,
          desc = 'Harpoon Quick Menu',
        },
      }
      for i = 1, 9 do
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

  {
    'folke/trouble.nvim',
    cmd = 'Trouble',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = { auto_preview = true, focus = true },
  },

  -- Outline
  {
    'hedyhli/outline.nvim',
    cmd = { 'Outline', 'OutlineOpen' },
    keys = { { '<F2>', '<cmd>Outline<CR>', desc = 'Toggle outline' } },
    opts = {},
  },

  -- BQF (quickfix mejorado)
  { 'kevinhwang91/nvim-bqf', ft = 'qf', opts = { auto_enable = true } },
}
