return {
  'nvim-telescope/telescope.nvim',
  event = 'VimEnter',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    'nvim-telescope/telescope-ui-select.nvim',
    { 'nvim-tree/nvim-web-devicons', enabled = true },
  },
  config = function()
    local telescope = require 'telescope'
    local actions = require 'telescope.actions'
    local builtin = require 'telescope.builtin'
    local themes = require 'telescope.themes'

    telescope.setup {
      defaults = {
        prompt_prefix = '   ',
        selection_caret = '❯ ',
        path_display = { 'truncate' },
        borderchars = {
          prompt = { '━', '┃', '━', '┃', '┏', '┓', '┛', '┗' },
          preview = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
          results = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
        },
        vimgrep_arguments = {
          'rg',
          '--color=never',
          '--no-heading',
          '--with-filename',
          '--line-number',
          '--column',
          '--smart-case',
        },
        mappings = {
          i = {
            ['<C-u>'] = false,
            ['<C-d>'] = false,
          },
          n = {
            ['q'] = actions.close,
          },
        },
      },
      pickers = {
        buffers = {
          theme = 'dropdown',
          sort_mru = true,
          layout_config = { prompt_position = 'top' },
          previewer = false,
          ignore_current_buffer = true,
          initial_mode = 'normal',
          mappings = {
            i = { ['<C-d>'] = actions.delete_buffer },
            n = { ['dd'] = actions.delete_buffer },
          },
        },
      },
      extensions = {
        ['ui-select'] = themes.get_dropdown(),
      },
    }

    for _, ext in ipairs { 'fzf', 'ui-select' } do
      pcall(telescope.load_extension, ext)
    end

    -- **Mapeos universales y representativos**
    local keymaps = {
      { '<leader>sh', builtin.help_tags, '[S]earch [H]elp' },
      { '<leader>sk', builtin.keymaps, '[S]earch [K]eymaps' },
      { '<home>', builtin.find_files, '[S]earch [F]iles' },
      { '<leader>ss', builtin.builtin, '[S]earch [S]elect Telescope' },
      { '<leader>sw', builtin.grep_string, '[S]earch current [W]ord' },
      { '<leader>sg', builtin.live_grep, '[S]earch by [G]rep' },
      { '<leader>sd', builtin.diagnostics, '[S]earch [D]iagnostics' },
      { '<leader>sr', builtin.resume, '[S]earch [R]esume' },
      { '<leader>s.', builtin.oldfiles, '[S]earch Recent Files' },
      { '<leader><leader>', builtin.buffers, 'Find existing buffers' },
      {
        '<leader>/',
        function()
          builtin.current_buffer_fuzzy_find(themes.get_dropdown { winblend = 10, previewer = false })
        end,
        '[/] Fuzzily search in current buffer',
      },
      {
        '<leader>s/',
        function()
          builtin.live_grep { grep_open_files = true, prompt_title = 'Live Grep in Open Files' }
        end,
        '[S]earch [/] in Open Files',
      },
      {
        '<leader>sn',
        function()
          builtin.find_files { cwd = vim.fn.stdpath 'config' }
        end,
        '[S]earch [N]eovim files',
      },
    }

    -- **Configuración de selección unificada (sin conflictos con Zellij ni Windows)**
    telescope.setup {
      defaults = {
        mappings = {
          i = {
            ['<CR>'] = actions.select_default, -- Enter: Abre en la misma ventana
          },
          n = {
            ['H'] = actions.select_default, -- Misma ventana
            ['J'] = actions.select_vertical, -- División vertical
            ['K'] = actions.select_horizontal, -- División horizontal
            ['L'] = actions.select_tab, -- Nueva pestaña
          },
        },
      },
    }

    -- Aplicar mapeos
    for _, map in ipairs(keymaps) do
      vim.keymap.set('n', map[1], map[2], { desc = map[3] })
    end
  end,
}
