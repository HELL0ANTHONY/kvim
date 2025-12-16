return {
  'nvim-telescope/telescope.nvim',
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

  keys = {
    { '<leader>sh', '<cmd>Telescope help_tags<cr>', desc = '[S]earch [H]elp' },
    { '<leader>sk', '<cmd>Telescope keymaps<cr>', desc = '[S]earch [K]eymaps' },
    { '<home>', '<cmd>Telescope find_files<cr>', desc = 'Search Files' },
    { '<leader>sf', '<cmd>Telescope find_files<cr>', desc = '[S]earch [F]iles' },
    { '<leader>ss', '<cmd>Telescope builtin<cr>', desc = '[S]earch [S]elect Telescope' },
    { '<leader>sw', '<cmd>Telescope grep_string<cr>', desc = '[S]earch current [W]ord' },
    { '<leader>sg', '<cmd>Telescope live_grep<cr>', desc = '[S]earch by [G]rep' },
    { '<leader>sd', '<cmd>Telescope diagnostics<cr>', desc = '[S]earch [D]iagnostics' },
    { '<leader>sr', '<cmd>Telescope resume<cr>', desc = '[S]earch [R]esume' },
    { '<leader>s.', '<cmd>Telescope oldfiles<cr>', desc = '[S]earch Recent Files' },
    { '<leader><leader>', '<cmd>Telescope buffers<cr>', desc = 'Find existing buffers' },
    {
      '<leader>/',
      function()
        require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown { winblend = 10, previewer = false })
      end,
      desc = '[/] Fuzzily search in current buffer',
    },
    {
      '<leader>s/',
      function()
        require('telescope.builtin').live_grep { grep_open_files = true, prompt_title = 'Live Grep in Open Files' }
      end,
      desc = '[S]earch [/] in Open Files',
    },
    {
      '<leader>sn',
      function()
        require('telescope.builtin').find_files { cwd = vim.fn.stdpath 'config' }
      end,
      desc = '[S]earch [N]eovim files',
    },
  },

  config = function()
    local telescope = require 'telescope'
    local actions = require 'telescope.actions'
    local themes = require 'telescope.themes'

    -- Layout reutilizable
    local wide_layout = {
      width = 0.96,
      height = 0.92,
      horizontal = { preview_width = 0.72, results_width = 0.28 },
    }

    -- Archivos a excluir de grep
    local grep_ignore = {
      '--glob=!package-lock.json',
      '--glob=!yarn.lock',
      '--glob=!pnpm-lock.yaml',
      '--glob=!go.sum',
      '--glob=!go.work.sum',
      '--glob=!*.min.js',
      '--glob=!*.min.css',
      '--glob=!dist/*',
      '--glob=!node_modules/*',
      '--glob=!vendor/*',
      '--glob=!.git/*',
    }

    local vimgrep_args = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
    }
    -- Agregar exclusiones
    for _, glob in ipairs(grep_ignore) do
      table.insert(vimgrep_args, glob)
    end

    telescope.setup {
      defaults = {
        prompt_prefix = '   ',
        selection_caret = '❯ ',
        path_display = { 'truncate' },
        layout_strategy = 'horizontal',
        layout_config = {
          width = 0.96,
          height = 0.92,
          horizontal = { preview_width = 0.65, results_width = 0.35 },
        },
        borderchars = {
          prompt = { '━', '┃', '━', '┃', '┏', '┓', '┛', '┗' },
          preview = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
          results = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
        },
        vimgrep_arguments = vimgrep_args,
        mappings = {
          i = {
            ['<C-u>'] = false,
            ['<C-d>'] = false,
            ['<CR>'] = actions.select_default,
            ['<C-j>'] = actions.select_vertical,
            ['<C-k>'] = actions.select_horizontal,
            ['<C-t>'] = actions.select_tab,
          },
          n = {
            ['q'] = actions.close,
            ['H'] = actions.select_default,
            ['J'] = actions.select_vertical,
            ['K'] = actions.select_horizontal,
            ['L'] = actions.select_tab,
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
        live_grep = {
          layout_strategy = 'horizontal',
          layout_config = wide_layout,
        },
        grep_string = {
          layout_strategy = 'horizontal',
          layout_config = wide_layout,
        },
        find_files = {
          layout_strategy = 'horizontal',
          layout_config = wide_layout,
        },
      },

      extensions = {
        ['ui-select'] = themes.get_dropdown(),
      },
    }

    pcall(telescope.load_extension, 'fzf')
    pcall(telescope.load_extension, 'ui-select')
  end,
}
