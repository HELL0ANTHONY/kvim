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

    -- Configuración de Telescope
    telescope.setup {
      defaults = {
        prompt_prefix = '   ',
        selection_caret = '❯ ',
      },
      pickers = {

        buffers = {
          ignore_current_buffer = true,
          theme = 'dropdown',
          layout_config = {
            prompt_position = 'top', -- Separa el prompt de los resultados
          },
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

    -- Cargar extensiones de forma más limpia
    for _, ext in ipairs { 'fzf', 'ui-select' } do
      pcall(telescope.load_extension, ext)
    end

    -- Mapeos de teclas
    local keymaps = {
      { '<leader>sh', builtin.help_tags, '[S]earch [H]elp' },
      { '<leader>sk', builtin.keymaps, '[S]earch [K]eymaps' },
      { '<home>', builtin.find_files, '[S]earch [F]iles' },
      { '<leader>ss', builtin.builtin, '[S]earch [S]elect Telescope' },
      { '<leader>sw', builtin.grep_string, '[S]earch current [W]ord' },
      { '<leader>sg', builtin.live_grep, '[S]earch by [G]rep' },
      { '<leader>sd', builtin.diagnostics, '[S]earch [D]iagnostics' },
      { '<leader>sr', builtin.resume, '[S]earch [R]esume' },
      { '<leader>s.', builtin.oldfiles, '[S]earch Recent Files ("." for repeat)' },
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

    -- Aplicar mapeos
    for _, map in ipairs(keymaps) do
      vim.keymap.set('n', map[1], map[2], { desc = map[3] })
    end
  end,
}
