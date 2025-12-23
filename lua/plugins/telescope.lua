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
    'nvim-tree/nvim-web-devicons',
    'folke/trouble.nvim',
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
      desc = 'Fuzzily search in buffer',
    },
    {
      '<leader>sn',
      function()
        require('telescope.builtin').find_files { cwd = vim.fn.stdpath 'config' }
      end,
      desc = '[S]earch [N]eovim files',
    },
    -- Trouble integration
    { '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', desc = 'Diagnostics (Trouble)' },
    { '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', desc = 'Buffer Diagnostics' },
  },
  config = function()
    local telescope = require 'telescope'
    local actions = require 'telescope.actions'
    local open_with_trouble = require('trouble.sources.telescope').open

    local wide = { width = 0.96, height = 0.92, horizontal = { preview_width = 0.72, results_width = 0.28 } }

    local grep_ignore = {
      '--glob=!package-lock.json',
      '--glob=!yarn.lock',
      '--glob=!pnpm-lock.yaml',
      '--glob=!go.sum',
      '--glob=!*.min.js',
      '--glob=!*.min.css',
      '--glob=!dist/*',
      '--glob=!node_modules/*',
      '--glob=!vendor/*',
      '--glob=!.git/*',
    }
    local vimgrep_args = { 'rg', '--color=never', '--no-heading', '--with-filename', '--line-number', '--column', '--smart-case' }
    for _, g in ipairs(grep_ignore) do
      table.insert(vimgrep_args, g)
    end

    telescope.setup {
      defaults = {
        prompt_prefix = '  ',
        selection_caret = '❯ ',
        path_display = { 'truncate' },
        layout_strategy = 'horizontal',
        layout_config = { width = 0.96, height = 0.92, horizontal = { preview_width = 0.65, results_width = 0.35 } },
        vimgrep_arguments = vimgrep_args,
        mappings = {
          i = {
            ['<C-u>'] = false,
            ['<C-d>'] = false,
            ['<CR>'] = actions.select_default,
            ['<C-j>'] = actions.select_vertical,
            ['<C-k>'] = actions.select_horizontal,
            ['<C-t>'] = actions.select_tab,
            ['<C-q>'] = open_with_trouble, -- Enviar a Trouble
          },
          n = {
            ['q'] = actions.close,
            ['H'] = actions.select_default,
            ['J'] = actions.select_vertical,
            ['K'] = actions.select_horizontal,
            ['L'] = actions.select_tab,
            ['<C-q>'] = open_with_trouble,
          },
        },
      },
      pickers = {
        buffers = {
          theme = 'dropdown',
          sort_mru = true,
          previewer = false,
          ignore_current_buffer = true,
          initial_mode = 'normal',
          mappings = { n = { ['dd'] = actions.delete_buffer } },
        },
        live_grep = { layout_config = wide },
        grep_string = { layout_config = wide },
        find_files = { layout_config = wide },
      },
      extensions = { ['ui-select'] = require('telescope.themes').get_dropdown() },
    }
    pcall(telescope.load_extension, 'fzf')
    pcall(telescope.load_extension, 'ui-select')
  end,
}
