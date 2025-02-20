return {
  'stevearc/oil.nvim',
  keys = {
    -- {
    --   '-',
    --   function()
    --     require('oil').open()
    --   end,
    --   desc = 'Open parent directory',
    -- },
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
    float = { max_height = 10, max_width = 50 },
    keymaps = {
      ['g?'] = { 'actions.show_help', mode = 'n' },
      ['<CR>'] = 'actions.select',
      ['<C-j>'] = { 'actions.select', opts = { vertical = true } },
      ['<C-k>'] = { 'actions.select', opts = { horizontal = true } },
      ['<C-t>'] = { 'actions.select', opts = { tab = true } },
      ['<C-p>'] = 'actions.preview',
      ['q'] = { 'actions.close', mode = 'n' },
      ['<C-l>'] = 'actions.refresh',
      ['-'] = { 'actions.parent', mode = 'n' },
      ['_'] = { 'actions.open_cwd', mode = 'n' },
      ['`'] = { 'actions.cd', mode = 'n' },
      ['~'] = { 'actions.cd', opts = { scope = 'tab' }, mode = 'n' },
      ['gs'] = { 'actions.change_sort', mode = 'n' },
      ['gx'] = 'actions.open_external',
      ['g.'] = { 'actions.toggle_hidden', mode = 'n' },
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
            [StatusType.Unmodified] = ' ',
            [StatusType.Unmerged] = '',
            [StatusType.Untracked] = '',
            [StatusType.External] = '',

            [StatusType.UpstreamAdded] = '󰈞',
            [StatusType.UpstreamCopied] = '󰈢',
            [StatusType.UpstreamDeleted] = '',
            [StatusType.UpstreamIgnored] = ' ',
            [StatusType.UpstreamModified] = '󰏫',
            [StatusType.UpstreamRenamed] = '',
            [StatusType.UpstreamTypeChanged] = '󱧶',
            [StatusType.UpstreamUnmodified] = ' ',
            [StatusType.UpstreamUnmerged] = '',
            [StatusType.UpstreamUntracked] = ' ',
            [StatusType.UpstreamExternal] = '',
          },

          status_hl_group = {
            [StatusType.Added] = 'OilVcsStatusAdded',
            [StatusType.Copied] = 'OilVcsStatusCopied',
            [StatusType.Deleted] = 'OilVcsStatusDeleted',
            [StatusType.Ignored] = 'OilVcsStatusIgnored',
            [StatusType.Modified] = 'OilVcsStatusModified',
            [StatusType.Renamed] = 'OilVcsStatusRenamed',
            [StatusType.TypeChanged] = 'OilVcsStatusTypeChanged',
            [StatusType.Unmodified] = 'OilVcsStatusUnmodified',
            [StatusType.Unmerged] = 'OilVcsStatusUnmerged',
            [StatusType.Untracked] = 'OilVcsStatusUntracked',
            [StatusType.External] = 'OilVcsStatusExternal',

            [StatusType.UpstreamAdded] = 'OilVcsStatusUpstreamAdded',
            [StatusType.UpstreamCopied] = 'OilVcsStatusUpstreamCopied',
            [StatusType.UpstreamDeleted] = 'OilVcsStatusUpstreamDeleted',
            [StatusType.UpstreamIgnored] = 'OilVcsStatusUpstreamIgnored',
            [StatusType.UpstreamModified] = 'OilVcsStatusUpstreamModified',
            [StatusType.UpstreamRenamed] = 'OilVcsStatusUpstreamRenamed',
            [StatusType.UpstreamTypeChanged] = 'OilVcsStatusUpstreamTypeChanged',
            [StatusType.UpstreamUnmodified] = 'OilVcsStatusUpstreamUnmodified',
            [StatusType.UpstreamUnmerged] = 'OilVcsStatusUpstreamUnmerged',
            [StatusType.UpstreamUntracked] = 'OilVcsStatusUpstreamUntracked',
            [StatusType.UpstreamExternal] = 'OilVcsStatusUpstreamExternal',
          },
        }
      end,
    },
  },
}
