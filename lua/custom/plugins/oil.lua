return {
  'stevearc/oil.nvim',
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
          },
        }
      end,
    },
  },
  opts = {
    default_file_explorer = false,
    win_options = {
      signcolumn = 'yes:2',
    },
    float = {
      max_height = 20,
      max_width = 60,
    },
    keymaps = {
      ['g?'] = { 'actions.show_help', mode = 'n' },
      ['<CR>'] = 'actions.select',
      ['<C-v>'] = { 'actions.select', opts = { vertical = true } },
      ['<C-x>'] = { 'actions.select', opts = { horizontal = true } },
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
}
