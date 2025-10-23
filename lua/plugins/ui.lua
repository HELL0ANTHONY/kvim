return {
  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    opts = {
      icons = {
        mappings = true,
        keys = {},
      },
      spec = {
        { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
        { '<leader>d', group = '[D]ocument' },
        { '<leader>r', group = '[R]ename' },
        { '<leader>s', group = '[S]earch' },
        { '<leader>w', group = '[W]orkspace' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      },
    },
  },
  {
    'sainnhe/gruvbox-material',
    priority = 1000,
    lazy = false,
    config = function()
      vim.g.gruvbox_material_background = 'medium' -- hard, soft, medium
      vim.g.gruvbox_material_foreground = 'material' -- original, mix, material
      vim.g.gruvbox_material_enable_italic = 1
      vim.g.gruvbox_material_enable_bold = 1
      vim.g.gruvbox_material_sign_column_background = 'none'
      vim.g.gruvbox_material_diagnostic_virtual_text = 'colored' -- 'grey'`, `'colored'`, `'highlighted'
    end,
    init = function()
      vim.cmd.colorscheme 'gruvbox-material'
    end,
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    event = 'VeryLazy',
    opts = function()
      local function is_vsplit()
        -- Detecta si el layout superior es 'row' (ventanas lado a lado)
        local function has_row(node)
          if not node or type(node) ~= 'table' then
            return false
          end
          if node[1] == 'row' then
            return true
          end
          for i = 2, #node do
            if has_row(node[i]) then
              return true
            end
          end
          return false
        end
        return has_row(vim.fn.winlayout())
      end

      local function win_is_narrow(w)
        w = w or 0
        return vim.api.nvim_win_get_width(w) < 60
      end

      local function file_icon()
        local ok, dev = pcall(require, 'nvim-web-devicons')
        if not ok then
          return ''
        end
        local name, ext = vim.fn.expand '%:t', vim.fn.expand '%:e'
        local icon = dev.get_icon(name, ext, { default = true })
        return icon and (icon .. ' ') or ''
      end

      -- Nombre de archivo:
      -- - En vsplit o ventana angosta => solo nombre
      -- - Caso normal => ruta relativa (desde cwd)
      local function smart_filename()
        local name = ''
        if is_vsplit() or win_is_narrow(0) then
          name = vim.fn.expand '%:t'
        else
          -- relativo a cwd (si querés relativo a raíz git, se puede ajustar)
          name = vim.fn.fnamemodify(vim.fn.expand '%:p', ':.')
        end
        if name == '' then
          name = '[No Name]'
        end

        local modified = vim.bo.modified and ' [+]' or ''
        return file_icon() .. name .. modified
      end

      -- Diagnósticos con íconos
      local diagnostics = {
        'diagnostics',
        sources = { 'nvim_diagnostic' },
        sections = { 'error', 'warn', 'info', 'hint' },
        symbols = { error = ' ', warn = ' ', info = ' ', hint = '󱐋 ' },
        colored = true,
        update_in_insert = false,
        always_visible = true,
      }

      -- Diff (usa gitsigns si está)
      local diff = {
        'diff',
        symbols = { added = ' ', modified = ' ', removed = ' ' },
        colored = true,
        cond = function()
          return not win_is_narrow(0)
        end,
      }

      -- Línea/columna + total
      local function cursor_and_total()
        local l = vim.fn.line '.'
        local c = vim.fn.col '.'
        local total = vim.api.nvim_buf_line_count(0)
        if win_is_narrow(0) then
          return string.format('%d/%d', l, total)
        end
        return string.format('󰉸 %d│󱥖 %d  /%d', l, c, total)
      end

      -- reemplazá el componente de branch por este
      local branch = {
        'branch',
        icon = '',
        color = { gui = 'bold' },
        -- oculta branch cuando hay vsplit
        cond = function()
          return not is_vsplit()
        end,
        -- (opcional) si NO hay vsplit, recorta nombres muy largos
        -- fmt = function(head)
        --   if not head then
        --     return ''
        --   end
        --   return (#head > 24) and (head:sub(1, 21) .. '…') or head
        -- end,
      }

      return {
        options = {
          theme = 'auto',
          -- Por ventana para que en vsplit ambos lados muestren su info
          globalstatus = false,
          section_separators = '',
          component_separators = '',
          disabled_filetypes = { statusline = {} },
          icons_enabled = true,
        },
        sections = {
          -- sin modo
          lualine_a = {},
          -- Branch + Diff
          lualine_b = {
            -- { 'branch', icon = '', color = { gui = 'bold' } },
            branch,
            diff,
          },
          -- Nombre (path inteligente)
          lualine_c = {
            { smart_filename, padding = 1 },
          },
          -- Nada “ruidoso” en X
          lualine_x = {
            diagnostics, -- a la derecha pero visible en todas las ventanas
          },
          -- Posición + total líneas
          lualine_y = {
            { cursor_and_total, padding = 1 },
          },
          lualine_z = {},
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { { smart_filename } },
          lualine_x = { diagnostics },
          lualine_y = {},
          lualine_z = {},
        },
        extensions = { 'quickfix', 'fugitive', 'man', 'nvim-tree', 'lazy' },
      }
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      ensure_installed = {
        'bash',
        'css',
        'go',
        'gomod',
        'gosum',
        'html',
        'javascript',
        'json',
        'lua',
        'markdown',
        'markdown_inline',
        'terraform',
        'toml',
        'tsx',
        'typescript',
        'vim',
        'vimdoc',
        'yaml',
      },
      highlight = { enable = true },
      indent = { enable = true },
      incremental_selection = { enable = true },
    },

    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
    end,
  },
  {
    'HiPhish/rainbow-delimiters.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local ok, rainbow_delimiters = pcall(require, 'rainbow-delimiters')
      if not ok then
        return
      end

      local colors = {
        Blue = 'Blue',
        Cyan = 'Cyan',
        Green = 'Green',
        Orange = 'Orange',
        Red = 'Red',
        Violet = 'Violet',
        Yellow = 'Yellow',
      }

      for name, link in pairs(colors) do
        vim.cmd(('highlight link RainbowDelimiter%s %s'):format(name, link))
      end

      vim.g.rainbow_delimiters = {
        strategy = {
          [''] = rainbow_delimiters.strategy['global'],
          vim = rainbow_delimiters.strategy['local'],
        },
        query = {
          [''] = 'rainbow-delimiters',
          go = 'rainbow-parens',
          html = 'rainbow-parens',
          javascript = 'rainbow-parens',
          javascriptreact = 'rainbow-parens',
          jsx = 'rainbow-parens',
          lua = 'rainbow-blocks',
          tsx = 'rainbow-parens',
          typescript = 'rainbow-parens',
          typescriptreact = 'rainbow-parens',
        },

        highlight = vim.tbl_keys(colors),
      }
    end,
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    ft = {
      'yaml',
      'python',
      'tf',
      'hcl',
      'tpl',
    },
    config = function()
      require('ibl').setup {
        scope = { enabled = false, show_start = false },
        whitespace = {
          highlight = { 'CursorColumn', 'Whitespace' },
          remove_blankline_trail = false,
        },
        indent = {
          highlight = { 'CursorColumn', 'Whitespace' },
          char = '',
        },
        exclude = {
          filetypes = {
            'help',
            'startify',
            'dashboard',
            'lazy',
            'neogitstatus',
            'NvimTree',
            'Trouble',
            'text',
          },
        },
      }
    end,
  },
}
