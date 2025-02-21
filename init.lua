-- [marks]: https://vim.fandom.com/wiki/Using_marks

require 'config'

require('lazy').setup({
  'tpope/vim-sleuth',

  {
    -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter',
    opts = {
      icons = {
        -- set icon mappings to true if you have a Nerd Font
        mappings = true, -- vim.g.have_nerd_font,

        -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
        -- default whick-key.nvim defined Nerd Font icons, otherwise define a string table
        keys = {},
      },

      -- Document existing key chains
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

  -- LSP Plugins
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
      },
    },
  },
  { 'Bilal2453/luvit-meta', lazy = true },

  {
    'sainnhe/gruvbox-material',
    lazy = false,
    priority = 1000,
    lazy = false,
    config = function()
      vim.g.gruvbox_material_background = 'medium' -- hard, soft, medium
      vim.g.gruvbox_material_foreground = 'material' -- original, mix, material
      vim.g.gruvbox_material_enable_italic = 1
      vim.g.gruvbox_material_sign_column_background = 'none'
      vim.g.gruvbox_material_diagnostic_virtual_text = 'colored' -- 'grey'`, `'colored'`, `'highlighted'


      local grpid = vim.api.nvim_create_augroup('custom_highlights_gruvboxmaterial', {})
      vim.api.nvim_create_autocmd('ColorScheme', {
        group = grpid,
        pattern = 'gruvbox-material',
        command = 'hi NvimTreeNormal                     guibg=#181818 |'
          .. 'hi NvimTreeEndOfBuffer                guibg=#181818 |'
          .. 'hi NoiceCmdlinePopupBorderCmdline     guifg=#ea6962 guibg=#282828 |'
          .. 'hi TelescopePromptBorder              guifg=#ea6962 guibg=#282828 |'
          .. 'hi TelescopePromptNormal              guifg=#ea6962 guibg=#282828 |'
          .. 'hi TelescopePromptTitle               guifg=#ea6962 guibg=#282828 |'
          .. 'hi TelescopePromptPrefix              guifg=#ea6962 guibg=#282828 |'
          .. 'hi TelescopePromptCounter             guifg=#ea6962 guibg=#282828 |'
          .. 'hi TelescopePreviewTitle              guifg=#89b482 guibg=#282828 |'
          .. 'hi TelescopePreviewBorder             guifg=#89b482 guibg=#282828 |'
          .. 'hi TelescopeResultsTitle              guifg=#89b482 guibg=#282828 |'
          .. 'hi TelescopeResultsBorder             guifg=#89b482 guibg=#282828 |'
          .. 'hi TelescopeMatching                  guifg=#d8a657 guibg=#282828 |'
          .. 'hi TelescopeSelection                 guifg=#ffffff guibg=#32302f |'
          .. 'hi FloatBorder                        guifg=#ea6962 guibg=#282828 |'
          .. 'hi BqfPreviewBorder                   guifg=#ea6962 guibg=#282828 |'
          .. 'hi NormalFloat                        guibg=#282828 |'
          .. 'hi IndentBlanklineContextChar         guifg=#d3869b |'
          .. 'hi StatusColumnBorder                 guifg=#232323 |'
          .. 'hi StatusColumnBuffer                 guibg=#282828 |'
          .. 'hi CursorLineNr                       guifg=#d8a657 |'
          .. 'hi CodewindowBorder                   guifg=#ea6962 |'
          .. 'hi TabLine                            guibg=#282828 |',
      })
    end,
    init = function()
      -- vim.cmd.colorscheme 'kanagawa'
      vim.cmd.colorscheme 'gruvbox-material'
    end,
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
          vim.keymap.set('n', '<C-v>', function()
            harpoon.ui:select_menu_item { vsplit = true }
          end, { buffer = cx.bufnr })

          vim.keymap.set('n', '<C-x>', function()
            harpoon.ui:select_menu_item { split = true }
          end, { buffer = cx.bufnr })

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

  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()
      require 'custom.plugins.mini.statusline'
      require 'custom.plugins.mini.icons'
      -- require 'custom.plugins.mini.diff'
    end,
  },

  -- The following two comments only work if you have downloaded the kickstart repo, not just copy pasted the
  -- init.lua. If you want these files, they are in the repository, so you can just download them and
  -- place them in the correct locations.

  -- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart
  --
  --  Here are some example plugins that I've included in the Kickstart repository.
  --  Uncomment any of the lines below to enable them (you will need to restart nvim).

  -- require 'kickstart.plugins.debug',
  -- require 'kickstart.plugins.indent_line',
  -- require 'kickstart.plugins.autopairs',
  -- require 'kickstart.plugins.neo-tree',
  require 'kickstart.plugins.gitsigns', -- adds gitsigns recommend keymaps

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    This is the easiest way to modularize your config.
  --
  --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  --    For additional information, see `:help lazy.nvim-lazy.nvim-structuring-your-plugins`
  { import = 'custom.plugins' },
}, {
  ui = {
    icons = {},
  },
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
