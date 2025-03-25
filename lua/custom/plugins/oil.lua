return {
  'stevearc/oil.nvim',

  keys = {
    {
      '-',
      function()
        require('oil').open_float()
      end,
      desc = 'Open parent directory in a floating window',
    },

    -- vim.keymap.set('n', '-', '<CMD>Oil --float<CR>', { desc = ' Open parent directory' })
  },
  opts = {
    default_file_explorer = true,
    win_options = { signcolumn = 'number' },
    view_options = { show_hidden = false },
    float = { max_height = 15, max_width = 80 },
    keymaps = {
      ['g?'] = { 'actions.show_help', mode = 'n' },
      ['<CR>'] = 'actions.select',
      ['J'] = { 'actions.select', opts = { vertical = true } },
      ['K'] = { 'actions.select', opts = { horizontal = true } },
      ['T'] = { 'actions.select', opts = { tab = true } }, -- Reemplaza <C-t>
      ['<Tab>'] = 'actions.preview', -- Reemplaza <C-p>
      ['q'] = { 'actions.close', mode = 'n' },
      ['<F5>'] = 'actions.refresh', -- Reemplaza <C-l>
      ['-'] = { 'actions.parent', mode = 'n' },
      ['_'] = { 'actions.open_cwd', mode = 'n' },
      ['`'] = { 'actions.cd', mode = 'n' },
      ['~'] = { 'actions.cd', opts = { scope = 'tab' }, mode = 'n' },
      ['S'] = { 'actions.change_sort', mode = 'n' }, -- Reemplaza gs
      ['gx'] = 'actions.open_external',
      ['H'] = { 'actions.toggle_hidden', mode = 'n' }, -- Reemplaza g.
      ['g\\'] = { 'actions.toggle_trash', mode = 'n' },
    },
  },

  dependencies = {
    'nvim-tree/nvim-web-devicons',
    {
      'SirZenith/oil-vcs-status',
      config = function()
        local status_const = require 'oil-vcs-status.constant.status'
        local StatusType = status_const.StatusType

        require('oil-vcs-status').setup {
          status_symbol = {
            [StatusType.Added] = '',
            [StatusType.Copied] = '󰆏',
            [StatusType.Deleted] = '',
            [StatusType.Ignored] = '',
            [StatusType.Modified] = '',
            [StatusType.Renamed] = '',
            [StatusType.TypeChanged] = '󰉺',
            [StatusType.Unmodified] = '',
            [StatusType.Unmerged] = '',
            [StatusType.Untracked] = '',
            [StatusType.External] = '',

            [StatusType.UpstreamAdded] = '',
            [StatusType.UpstreamCopied] = '󰆏',
            [StatusType.UpstreamDeleted] = '',
            [StatusType.UpstreamIgnored] = '',
            [StatusType.UpstreamModified] = '',
            [StatusType.UpstreamRenamed] = '',
            [StatusType.UpstreamTypeChanged] = '󰉺',
            [StatusType.UpstreamUnmodified] = '',
            [StatusType.UpstreamUnmerged] = '',
            [StatusType.UpstreamUntracked] = '',
            [StatusType.UpstreamExternal] = '',
          },

          status_hl_group = {
            [StatusType.Added] = 'Green',
            [StatusType.Copied] = 'Blue',
            [StatusType.Deleted] = 'Red',
            [StatusType.Ignored] = 'Gray',
            [StatusType.Modified] = 'Yellow',
            [StatusType.Renamed] = 'Blue',
            [StatusType.TypeChanged] = 'Magenta',
            [StatusType.Unmodified] = 'White',
            [StatusType.Unmerged] = 'Red',
            [StatusType.Untracked] = 'Cyan',
            [StatusType.External] = 'White',

            [StatusType.UpstreamAdded] = 'Green',
            [StatusType.UpstreamCopied] = 'Blue',
            [StatusType.UpstreamDeleted] = 'Red',
            [StatusType.UpstreamIgnored] = 'Gray',
            [StatusType.UpstreamModified] = 'Yellow',
            [StatusType.UpstreamRenamed] = 'Blue',
            [StatusType.UpstreamTypeChanged] = 'Magenta',
            [StatusType.UpstreamUnmodified] = 'White',
            [StatusType.UpstreamUnmerged] = 'Red',
            [StatusType.UpstreamUntracked] = 'Cyan',
            [StatusType.UpstreamExternal] = 'White',
          },
        }
      end,
    },
  },
}
